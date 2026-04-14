# bulala skill repo

This repository is structured as an installable Codex skill repository.

## Structure

- `skills/poc/SKILL.md`: Minimal fiat provider POC scenario skill.

## Quick install (manual)

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills/poc"
curl -L -sS "https://raw.githubusercontent.com/nobodydufer-droid/weekly-fiat-report/main/skills/poc/SKILL.md" \
  -o "${CODEX_HOME:-$HOME/.codex}/skills/poc/SKILL.md"
```

## One-command install

```bash
curl -L -sS "https://raw.githubusercontent.com/nobodydufer-droid/weekly-fiat-report/main/install.sh" | bash
```

## Verify

```bash
ls -la "${CODEX_HOME:-$HOME/.codex}/skills/poc/SKILL.md"
```

If you rename this repo to `bulala`, replace `weekly-fiat-report` in the URLs above with `bulala`.

