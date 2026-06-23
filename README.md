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

Formulae are automatically checked for new releases every hour and updated when upstream publishes a new version.

- [**update-stable**](.github/workflows/update-stable.yml) — tracks stable releases
- [**update-testing**](.github/workflows/update-testing.yml) — tracks pre-releases
