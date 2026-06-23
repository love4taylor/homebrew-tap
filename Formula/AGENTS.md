<!-- FOR AI AGENTS — Human readability is a side effect, not a goal -->
<!-- Managed by agent: keep sections and order; edit content, not structure -->

# AGENTS.md — Formula/

## Overview
Homebrew formulas for CLI tools and libraries. Convention: `Formula/<name>.rb`, class name in PascalCase. Tap-qualified name: `love4taylor/tap/<name>`.

## Setup
- Pre-edit: `brew edit love4taylor/tap/<name>` or directly edit file.
- Post-edit: `brew style`, `brew audit`, `brew fetch`, `brew install`, `brew test`.
- Use `brew create <url>` to scaffold a new formula, then copy into this tap.

## Commands
| Task | Command |
|------|---------|
| Lint | `brew style Formula/<name>.rb` |
| Audit | `brew audit --tap=love4taylor/tap --formula <name>` |
| Fetch | `brew fetch --formula love4taylor/tap/<name>` |
| Install | `brew install --formula love4taylor/tap/<name>` |
| Test | `brew test love4taylor/tap/<name>` |
| Readall | `brew readall --os=all --arch=all love4taylor/tap` |
| Livecheck | `brew livecheck love4taylor/tap/<name>` |

## Formula DSL (full order)

`desc` → `homepage` → `url`/`sha256` → `license` → `revision` → `version_scheme` → `head` → `depends_on` → `depends_on :macos`/`:linux` → `uses_from_macos` → `conflicts_with` → `keg_only` → `on_macos`/`on_linux`/`on_system` → `resource` → `patch` → `env` → `install` → `post_install`/`post_install_steps` → `caveats` → `service` → `test` → `livecheck`.

> **Binary formula exception:** when `on_macos` wraps `url`/`sha256`, place `on_macos`/`on_linux` directly after `license`, before `conflicts_with`. The linter accepts both.

## Source-Build Formula (Make/Autotools)
```ruby
class MyTool < Formula
  desc "Short description (no leading article)"
  homepage "https://example.com"
  url "https://example.com/my-tool-1.0.tar.gz"
  sha256 "..."
  license "MIT"
  depends_on "pkg-config" => :build
  depends_on "openssl"
  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end
  test do
    system "#{bin}/my-tool", "--version"
  end
end
```

## Source-Build (Meson/CMake/Go/Cargo)
```ruby
# Meson
def install
  system "meson", "setup", "build", *std_meson_args
  system "meson", "compile", "-C", "build"
  system "meson", "install", "-C", "build"
end

# CMake
def install
  system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  system "cmake", "--build", "build"
  system "cmake", "--install", "build"
end

# Go
depends_on "go" => :build
def install
  system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/my-tool"
end

# Rust/Cargo
depends_on "rust" => :build
def install
  system "cargo", "install", *std_cargo_args
end
```

## Binary Formula (pre-built)
```ruby
class MyTool < Formula
  desc "..."
  homepage "..."
  version "1.0"
  license "..."
  on_macos do
    if Hardware::CPU.arm?
      url "...-darwin-arm64.tar.gz"
      sha256 "..."
    else
      url "...-darwin-amd64.tar.gz"
      sha256 "..."
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "...-linux-arm64.tar.gz"
      sha256 "..."
    else
      url "...-linux-amd64.tar.gz"
      sha256 "..."
    end
  end
  def install
    bin.install "binary" => "my-tool"
  end
end
```

## Head / Git builds
```ruby
head "https://github.com/user/repo.git", branch: "main"
```

## Resources
```ruby
resource "extra-data" do
  url "..."
  sha256 "..."
end
def install
  resource("extra-data").stage { ... }
end
```

## Platform & Architecture
```ruby
depends_on :macos
depends_on :linux
depends_on macos: :sonoma
depends_on arch: :x86_64
depends_on arch: :arm64
uses_from_macos "bzip2"
uses_from_macos "curl", since: :monterey
on_macos do ... end
on_linux do ... end
on_arm do ... end
on_intel do ... end
on_system :linux, macos: :ventura do ... end
```

## Path helpers
| Path | Meaning |
|------|---------|
| `prefix` | `Cellar/<name>/<version>` |
| `bin` | `prefix/bin` |
| `lib` | `prefix/lib` |
| `etc` | persists across upgrades |
| `var` | persists across upgrades |
| `opt_prefix` | symlink to current version |
| `buildpath` | temp build dir |
| `pkgshare` | `prefix/share/<name>` |
| `HOMEBREW_PREFIX` | `$(brew --prefix)` |

## Service block
```ruby
service do
  run [opt_bin/"name", "arg"]
  run_type :immediate
  keep_alive true
  require_root true
  process_type :background
  environment_variables FOO: "bar"
  working_dir var/"lib/name"
  log_path var/"log/name.log"
  error_log_path var/"log/name.err.log"
end
```

## post_install_steps
```ruby
post_install_steps do
  mkdir_p "path", base: :etc
  mkdir_p "lib/name"
end
```
- Only specific step calls allowed; no arbitrary Ruby. Cannot have both `post_install` and `post_install_steps`.

## Livecheck
```ruby
livecheck do
  url "https://github.com/user/repo/releases/latest"
  regex(/v?(\d+(?:\.\d+)+)/i)
  strategy :github_latest
end
```

Common strategies: `:github_latest`, `:page_match`, `:sparkle`, `:electron_builder`.

## Security
- Always verify SHA256 of every binary asset.
- `require_root true` only when unavoidable (TUN, privileged ports).
- Never hardcode secrets in formulas.

## Code style
- Indent 2 spaces. No tabs.
- One space inside `{ }`. No space before `(`.
- Prefer `system` over backticks.
- `do ... end` for multi-line, `{ ... }` for single-line.

## Examples
- `sing-box-ref1nd.rb` — binary formula, explicit version, per-platform URLs, root service.
- `sing-box-ref1nd-testing.rb` — binary formula, auto-detected version (no `version` line).

## Checklist
- [ ] `brew style` passes
- [ ] `brew audit` passes
- [ ] `brew fetch` resolves all URLs
- [ ] `brew install` succeeds
- [ ] `brew test` passes
- [ ] `brew readall love4taylor/tap` passes

## When stuck
- Run `brew style --fix` to auto-correct ordering issues.
- Check homebrew-core: `brew edit <name>`.
- `brew install --verbose --debug` for detailed output.
