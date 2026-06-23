<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# 🍺 love4taylor/tap

Homebrew tap for miscellaneous formulae and casks.

</div>

## Install

```bash
brew tap love4taylor/tap
brew install <formula>
```

Or install directly without tapping first:

```bash
brew install love4taylor/tap/<formula>
```

## Formulae

| Formula | Description | Version |
|---------|-------------|---------|
| `sing-box-ref1nd` | Universal proxy platform (reF1nd fork) — stable | [![stable](https://img.shields.io/github/v/release/reF1nd/sing-box-releases?filter=!*-alpha*&label=)](https://github.com/reF1nd/sing-box-releases/releases) |
| `sing-box-ref1nd-testing` | Universal proxy platform (reF1nd fork) — testing | [![testing](https://img.shields.io/github/v/release/reF1nd/sing-box-releases?filter=*-alpha*&label=)](https://github.com/reF1nd/sing-box-releases/releases) |

## Updates

Formulae with upstream GitHub Releases are checked hourly and updated automatically when a new version is published.

| Workflow | Formula | Channel |
|----------|---------|---------|
| [`update-sing-box-ref1nd-stable`](.github/workflows/update-sing-box-ref1nd-stable.yml) | `sing-box-ref1nd` | stable |
| [`update-sing-box-ref1nd-testing`](.github/workflows/update-sing-box-ref1nd-testing.yml) | `sing-box-ref1nd` | pre-release |
