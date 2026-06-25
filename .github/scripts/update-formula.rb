#!/usr/bin/env ruby
# frozen_string_literal: true

# Updates sing-box-ref1nd formula when a new release is published.
# Usage: ruby update-formula.rb --stable | --testing

require "json"
require "digest/sha2"
require "open3"
require "rubygems"

TYPE = ARGV.find { |a| a.start_with?("--") }&.sub("--", "")
unless %w[stable testing].include?(TYPE)
  abort "Usage: #{$PROGRAM_NAME} --stable | --testing"
end

UPSTREAM_REPO  = "reF1nd/sing-box-releases"
TAP_REPO       = ENV.fetch("GITHUB_REPOSITORY", "love4taylor/homebrew-tap")
API            = "https://api.github.com/repos/#{UPSTREAM_REPO}/releases?per_page=20"
GITHUB_TOKEN   = ENV.fetch("GITHUB_TOKEN") { abort "GITHUB_TOKEN not set" }
GITHUB_API     = "https://api.github.com"

PLATFORMS = %w[darwin-amd64 darwin-arm64 linux-amd64-musl linux-arm64-musl]

FORMULA_FILE = if TYPE == "stable"
                 "Formula/sing-box-ref1nd.rb"
               else
                 "Formula/sing-box-ref1nd-testing.rb"
               end

# ── rollback on upstream deletion ────────────────────────────────────────

def rollback_formula(cur_ver, upstream_versions, formula_file, type)
  # 1. Sync with remote to avoid push conflicts
  sh("git pull --ff-only origin main")

  # 2. Get commits touching this formula file, newest first
  log = sh("git log --format='%H|||%s' -- #{formula_file}")
  abort "No git history found for #{formula_file}; cannot determine what to revert." if log.strip.empty?

  # 3. Scan forward: collect SHAs whose version is no longer in upstream
  shas_to_revert = []
  log.each_line do |line|
    sha, msg = line.strip.split("|||", 2)
    if msg&.match?(/^#{Regexp.escape(type)}: bump to (.+)$/)
      commit_ver = $1
      unless upstream_versions.include?(commit_ver)
        shas_to_revert << sha
        next
      end
    end
    # Stop at the first commit we don't want to revert
    break
  end

  abort "No revert targets found for #{formula_file}." if shas_to_revert.empty?

  puts "Reverting #{shas_to_revert.length} commit(s): #{shas_to_revert.join(', ')}"

  # 4. Build merged revert message
  revert_messages = shas_to_revert.map do |sha|
    orig_msg = sh("git log -1 --format='%s' #{sha}").strip
    "Revert \"#{orig_msg}\"\n\nThis reverts commit #{sha}.\n"
  end
  commit_msg = revert_messages.join("\n")

  # 5. Revert all into index without committing
  sh("git revert --no-commit #{shas_to_revert.join(' ')}")

  # 6. Commit with merged message via tempfile (avoids shell escaping issues)
  require "tempfile"
  msg_file = Tempfile.new("revert-commit-msg")
  msg_file.write(commit_msg)
  msg_file.close
  sh("git commit -F '#{msg_file.path}'")
  msg_file.unlink

  # 7. Push
  sh("git push origin main")

  puts "Reverted to latest upstream version. Done."
  exit 0
rescue Exception => e
  system("git reset --hard HEAD")
  raise if e.is_a?(SystemExit) || e.is_a?(SignalException)
  abort "Rollback failed: #{e.message}"
end

# ── helpers ────────────────────────────────────────────────────────────

def sh(*cmd)
  out, status = Open3.capture2e(*cmd)
  abort "#{cmd.inspect} failed: #{out}" unless status.success?
  out
end

def gh_api(method, path, body = nil)
  args = ["curl", "-fsS", "-X", method,
          "-H", "Authorization: Bearer #{GITHUB_TOKEN}",
          "-H", "Accept: application/vnd.github+json",
          "-H", "X-GitHub-Api-Version: 2022-11-28",
          "#{GITHUB_API}#{path}"]
  args += ["-d", JSON.generate(body)] if body
  JSON.parse(sh(*args))
end

# ── 1. fetch latest release ────────────────────────────────────────────

releases = JSON.parse(sh("curl -fsS --retry 3 -H 'Authorization: Bearer #{GITHUB_TOKEN}' #{API}"))
            .reject { |r| r["draft"] || r["tag_name"].nil? }

upstream_versions = releases.map { |r| r["tag_name"]&.sub(/^v/, "")&.sub(/-reF1nd.*/, "") }.compact

def prerelease_tag?(tag)
  tag&.match?(/(?:alpha|beta|rc)[.\d-]/i) || false
end

latest = if TYPE == "stable"
           releases.select { |r| !prerelease_tag?(r["tag_name"]) }
         else
           releases.select { |r| prerelease_tag?(r["tag_name"]) }
         end.max_by { |r| Gem::Version.new(r["tag_name"].sub(/^v/, "").sub(/-reF1nd/, "")) }

abort "No #{TYPE} release found." unless latest

tag      = latest["tag_name"]                       # e.g. "v1.13.13-reF1nd" or "v1.13.14-reF1nd.1"
asset_id = tag.sub(/^v/, "")                        # e.g. "1.13.13-reF1nd" or "1.13.14-reF1nd.1"
new_ver  = asset_id.sub(/-reF1nd.*/, "")             # e.g. "1.13.13" or "1.13.14"
puts "Latest #{TYPE} release: #{tag}  →  version #{new_ver}"

# ── 2. compare with current formula ────────────────────────────────────

formula = File.read(FORMULA_FILE)
cur_ver = if TYPE == "stable"
            formula[/^\s*version\s+"([^"]+)"/, 1]
          else
            # Extract version from the release tag in the download URL
            tag_part = formula[%r{/download/v([^/]+)/}, 1]
            tag_part&.sub(/-reF1nd.*/, "")
          end

abort "Cannot parse current version from #{FORMULA_FILE}" unless cur_ver
puts "Current version in formula: #{cur_ver}"

# Extract the full asset identifier from the download URL (includes rebuild suffix)
current_asset = formula[%r{/download/v[^/]+/sing-box-(.+?)-(?:darwin|linux)}, 1]
abort "Cannot parse current asset from #{FORMULA_FILE}" unless current_asset

if current_asset == asset_id
  puts "Already up-to-date."
  exit 0
end

# Detect if upstream deleted the release our formula references
unless upstream_versions.include?(cur_ver)
  puts "Upstream deleted release v#{cur_ver}-reF1nd. Rolling back..."
  rollback_formula(cur_ver, upstream_versions, FORMULA_FILE, TYPE)
end

puts "New version available, updating..."

# ── 3. compute SHA256 for each platform ────────────────────────────────

BASE_URL = "https://github.com/#{UPSTREAM_REPO}/releases/download/#{tag}/sing-box-#{asset_id}"

sha256s = {}
PLATFORMS.each do |plat|
  url = "#{BASE_URL}-#{plat}.tar.gz"
  puts "  Downloading #{plat}..."
  data = sh("curl -sSfL '#{url}'")
  sha256s[plat] = Digest::SHA256.hexdigest(data)
  puts "    sha256: #{sha256s[plat]}"
end

# ── 4. update formula ──────────────────────────────────────────────────

updated = formula.dup

if TYPE == "stable"
  updated.sub!(/^(\s*version\s+)"[^"]+"/, %(\\1"#{new_ver}"))
end

PLATFORMS.each do |plat|
  new_url = "#{BASE_URL}-#{plat}.tar.gz"
  updated.sub!(%r{(\s+url\s+)"[^"]*-#{Regexp.escape(plat)}\.tar\.gz"}, %(\\1"#{new_url}"))
end

PLATFORMS.each do |plat|
  old_sha = formula[/#{Regexp.escape(plat)}\.tar\.gz"\s*\n\s+sha256\s+"([a-f0-9]+)"/, 1]
  if old_sha
    updated.sub!(old_sha, sha256s[plat])
  else
    abort "Cannot find old sha256 for #{plat}"
  end
end

if updated == formula
  abort "Formula unchanged after replacement — manual check needed."
end

puts "Updated #{FORMULA_FILE}."

# ── 5. commit via GitHub API (verified) ────────────────────────────────

# Get current HEAD
ref = gh_api("GET", "/repos/#{TAP_REPO}/git/ref/heads/main")
head_sha = ref["object"]["sha"]

# Get base commit (for tree and parent)
base_commit = gh_api("GET", "/repos/#{TAP_REPO}/git/commits/#{head_sha}")
tree_sha = base_commit["tree"]["sha"]

# Create blob with new formula content
blob = gh_api("POST", "/repos/#{TAP_REPO}/git/blobs", {
  content: updated,
  encoding: "utf-8"
})

# Create new tree
tree = gh_api("POST", "/repos/#{TAP_REPO}/git/trees", {
  base_tree: tree_sha,
  tree: [{ path: FORMULA_FILE, mode: "100644", type: "blob", sha: blob["sha"] }]
})

# Create commit
commit = gh_api("POST", "/repos/#{TAP_REPO}/git/commits", {
  message: "#{TYPE}: bump to #{new_ver}",
  tree: tree["sha"],
  parents: [head_sha]
})

# Update ref
gh_api("PATCH", "/repos/#{TAP_REPO}/git/refs/heads/main", {
  sha: commit["sha"],
  force: false
})

puts "Committed #{commit["sha"]} — #{commit["html_url"]}"
puts "Done."
