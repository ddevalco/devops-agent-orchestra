#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/prompts"
TARGET_DIR="$HOME/Library/Application Support/Code/User/prompts"

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

  base="$(basename "$src")"
  dest="$TARGET_DIR/${base}.agent.md"
  cp "$src" "$dest"
  installed=$((installed + 1))
done

echo "Installed/updated $installed global agents in: $TARGET_DIR"
echo "Skipped $skipped non-agent markdown files."
echo "Next: run 'Developer: Reload Window' in VS Code, then open the agent picker."
