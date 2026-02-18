#!/usr/bin/env bash
# Auto-fix markdown linting errors
# Usage: bash scripts/markdownlint-fix.sh [repo_path] [--check]

REPO_PATH="${1:-.}"
CHECK_ONLY="${2:-}"

cd "$REPO_PATH" || exit 1

if [ "$CHECK_ONLY" = "--check" ]; then
  echo "Checking (dry run) markdown files in: $REPO_PATH"
  npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules"
else
  echo "Auto-fixing markdown files in: $REPO_PATH"
  npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules" --fix
  echo "✓ Auto-fix complete. Run with --check to verify."
fi
