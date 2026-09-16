#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(git curl cc tree-sitter)
missing=()
for command in "${required[@]}"; do
  if ! command -v "$command" >/dev/null 2>&1; then
    missing+=("$command")
  fi
done

if ((${#missing[@]})); then
  printf 'Missing prerequisites: %s\n' "${missing[*]}" >&2
  printf 'Install them first, then run this script again.\n' >&2
  exit 1
fi

"$repo_root/scripts/nvim.sh" --headless "+lua require('config.bootstrap').run()" +qa
"$repo_root/scripts/check.sh"
"$repo_root/scripts/check-languages.sh"
