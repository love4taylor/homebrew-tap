<!-- FOR AI AGENTS — Human readability is a side effect, not a goal -->
<!-- Managed by agent: keep sections and order; edit content, not structure -->

# AGENTS.md

**Precedence:** the **closest `AGENTS.md`** to the files you're changing wins. Root holds global defaults only.

## Commands

| Task | Command | ~Time |
|------|---------|-------|
| Lint formula | `brew style Formula/<name>.rb` | ~2s |
| Audit formula | `brew audit --tap=love4taylor/tap --formula <name>` | ~3s |
| Audit cask | `brew audit --tap=love4taylor/tap --cask <name>` | ~3s |
| Install formula | `brew install --formula love4taylor/tap/<name>` | varies |
| Install cask | `brew install --cask love4taylor/tap/<name>` | varies |
| Readall | `brew readall --os=all --arch=all love4taylor/tap` | ~5s |

## Response Style
Answer by action, not explanation. Show output as evidence.

## Workflow
1. `Read` before `Edit`/`Write`. After edit: `brew style` + `brew audit`.
2. After URL/sha256 changes: `brew fetch`. After install logic: `brew install`.

## Scoped Files

| Directory | Guide | Contents |
|-----------|-------|----------|
| `Formula/` | `Formula/AGENTS.md` | Full DSL reference: source-build, binary, head, resources, service, test |
| `Casks/` | `Casks/AGENTS.md` | Full DSL reference: artifacts, pkg, uninstall, zap, livecheck |
| `.github/` | `.github/AGENTS.md` | Auto-update scripts, workflow patterns, error handling |

## Heuristics

| When | Do |
|------|-----|
| New formula (source) | `brew create <url>` scaffold → `Formula/` |
| New formula (binary) | See `Formula/AGENTS.md` binary template |
| New cask | `brew create --cask <url>` scaffold → `Casks/` |
| Update binary formula | See `.github/AGENTS.md` — auto-update only works for GitHub Releases with predictable asset names |
| Update source-build formula | `brew bump-formula-pr --url=<new-url>` then review |
| Update cask | `brew bump-cask-pr --version=<new-ver>` then review |
| Binary conflict | `bin.install "orig" => "tap‑prefixed-name"` |
| Need `etc/` or `var/` dirs | `post_install_steps { mkdir_p "path", base: :etc }` |
| Verification | `brew style` + `brew audit` + `brew fetch` + `brew test` |
