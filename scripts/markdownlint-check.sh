#!/usr/bin/env bash
# Check markdown files for linting errors
# Usage: bash scripts/markdownlint-check.sh [repo_path]

REPO_PATH="${1:-.}"
cd "$REPO_PATH" || exit 1

echo "Checking markdown files in: $REPO_PATH"
npx markdownlint-cli2 "**/*.md" "!node_modules" "!**/node_modules"
