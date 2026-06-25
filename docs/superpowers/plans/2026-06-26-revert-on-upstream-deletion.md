# Revert on Upstream Release Deletion — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When upstream deletes a GitHub Release that our formula currently references, use `git revert` (single merged commit) instead of forward-editing the file.

**Architecture:** Single-file change to `.github/scripts/update-formula.rb`. After determining `latest` release, check whether `cur_ver` exists in upstream. If not, enter a rollback branch that scans git log for consecutive deleted bump commits, reverts them with `--no-commit`, and commits as one merged revert.

**Tech Stack:** Ruby 3.3 stdlib (json, digest/sha2, open3, tempfile), git CLI, GitHub API.

---

### Task 1: Build upstream version set after fetching releases

**Files:**
- Modify: `.github/scripts/update-formula.rb:52-53`

- [ ] **Step 1: Add upstream version extraction**

After line 53 (after `releases = ...`), insert a helper to build a set of upstream version strings:

```ruby
upstream_versions = releases.map { |r| r["tag_name"]&.sub(/^v/, "")&.sub(/-reF1nd$/, "") }.compact
```

This extracts e.g. `"v1.13.13-reF1nd"` → `"1.13.13"` from every release in the fetched list.

- [ ] **Step 2: Commit**

```bash
git add .github/scripts/update-formula.rb
git commit -m "feat: build upstream version set for deletion detection"
```

---

### Task 2: Add rollback detection branch

**Files:**
- Modify: `.github/scripts/update-formula.rb:82-87`

- [ ] **Step 1: Insert deletion check between version comparison and forward-update path**

Replace lines 82-87:

```ruby
if cur_ver == new_ver
  puts "Already up-to-date."
  exit 0
end

puts "New version available, updating..."
```

With:

```ruby
if cur_ver == new_ver
  puts "Already up-to-date."
  exit 0
end

# Detect if upstream deleted the release our formula references
unless upstream_versions.include?(cur_ver)
  puts "Upstream deleted release v#{cur_ver}-reF1nd. Rolling back..."
  rollback_formula(cur_ver, upstream_versions, FORMULA_FILE, TYPE)
  # rollback_formula exits on completion or aborts on failure
end

puts "New version available, updating..."
```

- [ ] **Step 2: Commit**

```bash
git add .github/scripts/update-formula.rb
git commit -m "feat: add upstream deletion detection branch"
```

---

### Task 3: Implement `rollback_formula` function

**Files:**
- Modify: `.github/scripts/update-formula.rb` — insert function before helpers comment block (~line 31)

- [ ] **Step 1: Write the `rollback_formula` function**

Insert after the `PLATFORMS` constant (line 23) and before the helpers block (line 31):

```ruby
# ── rollback on upstream deletion ────────────────────────────────────────

def rollback_formula(cur_ver, upstream_versions, formula_file, type)
  # 1. Sync with remote to avoid push conflicts
  sh("git pull --ff-only origin main")

  # 2. Get commits touching this formula file, newest first
  log = sh("git log --format='%H|||%s' -- #{formula_file}")
  return if log.strip.empty?

  # 3. Scan forward: collect SHAs whose version is no longer in upstream
  shas_to_revert = []
  log.each_line do |line|
    sha, msg = line.strip.split("|||", 2)
    # Match "{type}: bump to {ver}"
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

  # 6. Commit with merged message via tempfile (avoids shell escaping)
  require "tempfile"
  msg_file = Tempfile.new("revert-commit-msg")
  msg_file.write(commit_msg)
  msg_file.close
  sh("git commit -F #{msg_file.path}")
  msg_file.unlink

  # 7. Push
  sh("git push origin main")

  puts "Reverted to latest upstream version. Done."
  exit 0
rescue => e
  # If revert was started but not committed, abort the revert
  system("git revert --abort 2>/dev/null")
  abort "Rollback failed: #{e.message}"
end
```

- [ ] **Step 2: Verify script syntax**

```bash
ruby -c .github/scripts/update-formula.rb
```
Expected: `Syntax OK`

- [ ] **Step 3: Commit**

```bash
git add .github/scripts/update-formula.rb
git commit -m "feat: implement rollback via git revert on upstream deletion"
```

---

### Task 4: Final verification

**Files:**
- (none modified, verification only)

- [ ] **Step 1: Lint and audit**

```bash
brew style Formula/sing-box-ref1nd.rb
brew style Formula/sing-box-ref1nd-testing.rb
brew audit --tap=love4taylor/tap --formula sing-box-ref1nd
brew audit --tap=love4taylor/tap --formula sing-box-ref1nd-testing
```
Expected: All pass (no changes to formula files, should still pass)

- [ ] **Step 2: Dry-run the script (stable)**

Simulate: temporarily change `exit 0` at the "already up-to-date" check to print and exit, then run:

```bash
ruby .github/scripts/update-formula.rb --stable
```
Expected: "Already up-to-date." (current formula already matches latest upstream)

- [ ] **Step 3: Dry-run the script (testing)**

```bash
ruby .github/scripts/update-formula.rb --testing
```
Expected: "Already up-to-date." (current formula already matches latest upstream)
