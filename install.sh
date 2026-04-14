#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://raw.githubusercontent.com/nobodydufer-droid/bulala/main}"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="${CODEX_HOME_DIR}/skills/poc"
TARGET_FILE="${TARGET_DIR}/SKILL.md"

mkdir -p "${TARGET_DIR}"
curl -L -sS "${REPO_URL}/skills/poc/SKILL.md" -o "${TARGET_FILE}"

echo "Installed: ${TARGET_FILE}"
