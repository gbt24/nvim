#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$repo_root/scripts/nvim.sh" --headless "+lua require('config.smoke').run()" +qa
"$repo_root/scripts/nvim.sh" --headless "+checkhealth config" +qa

