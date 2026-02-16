#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: scripts/install-workspace-agents.sh <workspace-root>"
  echo "Example: scripts/install-workspace-agents.sh /Users/danedevalcourt/iPhoneApp"
  exit 1
fi

WORKSPACE_ROOT="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/prompts"
TARGET_DIR="$WORKSPACE_ROOT/.github/agents"

mkdir -p "$TARGET_DIR"
installed=0
skipped=0

for src in "$SOURCE_DIR"/*.md; do
  [[ -f "$src" ]] || continue

  if ! head -n 1 "$src" | grep -q '^---$'; then
    skipped=$((skipped + 1))
    continue
  fi

  if ! head -n 30 "$src" | grep -q '^name:'; then
    skipped=$((skipped + 1))
    continue
  fi

  cp "$src" "$TARGET_DIR/$(basename "$src")"
  installed=$((installed + 1))
done

echo "Installed/updated $installed workspace agents in: $TARGET_DIR"
echo "Skipped $skipped non-agent markdown files."
echo "Next: run 'Developer: Reload Window' and reopen the agent picker."
