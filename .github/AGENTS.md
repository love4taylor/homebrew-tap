<!-- FOR AI AGENTS — Human readability is a side effect, not a goal -->
<!-- Managed by agent: keep sections and order; edit content, not structure -->

# AGENTS.md — .github/

## Overview
GitHub Actions workflows and automation scripts for this Homebrew tap.

## Setup
- Workflows use `ruby/setup-ruby@v1` with Ruby 3.3 on `ubuntu-latest`.
- Scripts are standalone Ruby files using stdlib only.
- Push to main requires `contents: write` permission; `GITHUB_TOKEN` must be injected via `env:`.

## When Auto-Update Works (and When It Doesn't)

The auto-update pattern applies **only** to **binary formulas** whose upstream publishes **multi-platform assets on GitHub Releases with predictable filenames**.

| Formula type | Auto-update? | Why |
|-------------|-------------|-----|
| Binary, GitHub Releases, predictable asset names | ✅ Yes | This is the only supported pattern. |
| Source-build (tarball/git) | ❌ No | Use `brew bump-formula-pr --url=<new-url>` manually. |
| Casks | ❌ No | Use `brew bump-cask-pr` or `brew livecheck`. |
| Non-GitHub upstream | ❌ No | Script relies on GitHub API. |

**Stable vs testing split:** Only when upstream uses the `prerelease` flag on GitHub Releases.

## Commands
| Task | Command |
|------|---------|
| Run update (stable) | `ruby .github/scripts/update-formula.rb --stable` |
| Run update (testing) | `ruby .github/scripts/update-formula.rb --testing` |
| Manual trigger | `gh workflow run update-stable.yml` |

## Auto-Update Script Pattern (binary + GitHub Releases only)

1. Fetch latest release from GitHub API
2. Compare version with current formula
3. If newer: download each platform asset, compute SHA256
4. Regex-replace version + all SHA256s in formula file
5. Commit via GitHub Git Database API (verified commit, no git push)

## Workflow Template
```yaml
name: Update <name>
on:
  schedule:
    - cron: "0 * * * *"
  workflow_dispatch:
concurrency: formula-update    # prevent parallel runs
jobs:
  update:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.3"
      - name: Run update script
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: ruby .github/scripts/update-<name>.rb --stable
```

## Code style
### Naming conventions
| Type | Convention | Example |
|------|------------|---------|
| Script file | `update-<formula>.rb` | `update-formula.rb` |
| Workflow file | `update-<formula>-<channel>.yml` | `update-sing-box-ref1nd-stable.yml` |

### Error handling in scripts
- Exit 0 on "already up-to-date" (not an error).
- Abort with `abort "message"` on API failure, missing release, or parse failure.
- Use `curl -fsSL`: fail on HTTP errors, silent, follow redirects.

## Security
- `GITHUB_TOKEN` is auto-provided; explicitly injected via `env:` in workflow step.
- Scripts read from GitHub API and local files only; no user input.

## Checklist
- [ ] Workflow includes `workflow_dispatch` for manual testing
- [ ] Script exits 0 on "already up-to-date"
- [ ] Script aborts with clear message on failures
- [ ] `concurrency` group prevents parallel runs

## Examples
- `update-formula.rb` — binary formula auto-update from GitHub Releases.
- `update-sing-box-ref1nd-stable.yml` / `update-sing-box-ref1nd-testing.yml` — per-channel workflows.

## When stuck
- Test script locally: `ruby .github/scripts/update-formula.rb --stable`
- Simulate old version: manually downgrade formula, run script, verify result.
- GitHub Actions: `gh run view --log` or Actions tab in repo.
