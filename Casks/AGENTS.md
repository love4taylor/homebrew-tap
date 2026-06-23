<!-- FOR AI AGENTS — Human readability is a side effect, not a goal -->
<!-- Managed by agent: keep sections and order; edit content, not structure -->

# AGENTS.md — Casks/

## Overview
Homebrew casks for macOS GUI apps, fonts, drivers, plugins. Convention: `Casks/<name>.rb`, token in lowercase (hyphens only, no underscores). Tap-qualified name: `love4taylor/tap/<name>`.

## Setup
- Scaffold: `brew create --cask <url>` then copy into `Casks/`.
- Post-edit: `brew audit --tap=love4taylor/tap --cask <name>`.
- Test: `brew install --cask love4taylor/tap/<name>`.

## Commands
| Task | Command |
|------|---------|
| Audit | `brew audit --tap=love4taylor/tap --cask <name>` |
| Install | `brew install --cask love4taylor/tap/<name>` |
| Reinstall | `brew reinstall --cask love4taylor/tap/<name>` |
| Uninstall | `brew uninstall --cask love4taylor/tap/<name>` |
| Zap | `brew uninstall --zap --cask love4taylor/tap/<name>` |
| Livecheck | `brew livecheck love4taylor/tap/<name>` |
| Fetch | `brew fetch --cask love4taylor/tap/<name>` |

## Cask DSL (full stanza order)

```
cask "token" do
  arch arm64: ..., intel: ...      # optional, first
  os macos: ...                    # optional

  version "1.0"
  sha256 "..."

  language "en", default: true do  # between sha256 and url
    "en-US"
  end

  url "..."
  name "App Name"
  desc "Short description"
  homepage "https://..."

  livecheck do ... end             # between homepage and auto_updates

  auto_updates true
  conflicts_with cask: "..."
  depends_on cask: "..."
  depends_on macos: :sonoma
  container nested: "...", type: :zip

  app "Foo.app"
  # ... other artifacts ...
  uninstall ...
  zap ...

  caveats do ... end
end
```

## Basic Template (.app)

```ruby
cask "my-app" do
  version "1.0.0,42"
  sha256 "..."

  url "https://example.com/MyApp-#{version.csv.first}.dmg"
  name "My App"
  desc "Short description — under 80 chars"
  homepage "https://example.com"

  app "MyApp.app"

  zap trash: [
    "~/Library/Application Support/MyApp",
    "~/Library/Preferences/com.example.myapp.plist",
  ]
end
```
- `version "1.0.0,42"` — `version.csv.first` = `1.0.0`, `version.csv.second` = `42`.
- `desc` ≤ 80 characters. No product name, vendor, platform, or marketing fluff.

## Artifacts (at least one required)

| Stanza | Destination |
|--------|-------------|
| `app "Foo.app"` | `/Applications` |
| `suite "Suite Dir"` | `/Applications` (entire directory) |
| `pkg "Foo.pkg"` | runs `installer` — *must* include `uninstall` |
| `installer manual: "..."` | user runs manually — *must* include `uninstall` |
| `installer script: { ... }` | runs install script — *must* include `uninstall` |
| `binary "bin/foo"` | `$(brew --prefix)/bin` |
| `manpage "foo.1"` | man page |
| `bash_completion "foo"` | shell completion |
| `font "Foo.ttf"` | `~/Library/Fonts` |
| `colorpicker "Foo.colorPicker"` | `~/Library/ColorPickers` |
| `dictionary "Foo.dictionary"` | `~/Library/Dictionaries` |
| `input_method "Foo.app"` | `~/Library/Input Methods` |
| `mdimporter "Foo.mdimporter"` | `~/Library/Spotlight` |
| `qlplugin "Foo.qlgenerator"` | `~/Library/QuickLook` |
| `screen_saver "Foo.saver"` | `~/Library/Screen Savers` |
| `audio_unit_plugin "Foo.component"` | `~/Library/Audio/Plug-Ins/Components` |
| `vst_plugin "Foo.vst"` | `~/Library/Audio/Plug-Ins/VST` |
| `artifact "path", target: "/absolute/path"` | arbitrary (requires absolute `target:`) |
| `stage_only true` | no linking, stays in Caskroom |

## uninstall (execution order is fixed)

| # | Sub-stanza | Purpose |
|---|-----------|---------|
| 1 | `early_script:` | run script before anything else |
| 2 | `launchctl:` | bootout launchd jobs |
| 3 | `quit:` | quit running apps |
| 4 | `signal:` | send Unix signals |
| 5 | `login_item:` | remove login items |
| 6 | `kext:` | unload kernel extensions |
| 7 | `script:` | run uninstall script |
| 8 | `pkgutil:` | uninstall packages |
| 9 | `delete:` | remove files/dirs |
| 10 | `rmdir:` | remove empty dirs |
| 11 | `trash:` | move to Trash |

## depends_on

```ruby
depends_on macos: :sonoma
depends_on macos: ">= :ventura"
depends_on arch: :arm64
depends_on cask: "other-cask"
depends_on formula: "other-formula"
```

## language blocks

```ruby
language "zh", "CN" do "zh_CN" end
language "en", default: true do "en_US" end

url "https://example.com/app-#{language}.dmg"
```
- One block must have `default: true`.

## container

```ruby
container nested: "Inner.dmg"
container type: :zip
```

Full types: `:air`, `:bz2`, `:cab`, `:dmg`, `:generic_unar`, `:gzip`, `:otf`, `:pkg`, `:rar`, `:seven_zip`, `:sit`, `:tar`, `:ttf`, `:xar`, `:zip`, `:naked`.

## Livecheck

```ruby
livecheck do
  url :stable
  strategy :github_latest
end
```

Common strategies: `:github_latest`, `:page_match`, `:sparkle`, `:electron_builder`.

## Security
- Always verify SHA256 of the downloaded artifact.
- Never bundle license keys, activation codes, or credentials.
- `verified:` parameter on `url` required when downloading from a different domain than homepage.

## Code style
- Cask token: lowercase, hyphens only, no underscores.
- `desc` ≤ 80 characters. No product name, vendor, platform.
- `name` first instance in Latin alphabet.
- Indent 2 spaces. No tabs.

## Examples
None yet — reference: `brew edit --cask firefox`.

## Checklist
- [ ] `brew audit --cask` passes
- [ ] `brew install --cask` succeeds
- [ ] `brew uninstall --zap --cask` cleans up
- [ ] `brew livecheck` returns correct version

## When stuck
- Run `brew create --cask <url>` on a throwaway machine to see auto-generated cask.
- Check `https://github.com/Homebrew/homebrew-cask` for similar apps.
