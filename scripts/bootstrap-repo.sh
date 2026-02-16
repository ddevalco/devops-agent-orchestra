#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  cat <<'USAGE'
Usage:
  scripts/bootstrap-repo.sh <github-remote-url> [default-branch]

Examples:
  scripts/bootstrap-repo.sh git@github.com:YOUR_ORG/dane-agent-orchestra.git
  scripts/bootstrap-repo.sh https://github.com/YOUR_ORG/dane-agent-orchestra.git main
USAGE
  exit 1
fi

REMOTE_URL="$1"
BRANCH="${2:-main}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

if [[ ! -d .git ]]; then
  git init
fi

git add .

git commit -m "Initial import: Dane Agent Orchestra" || true

git branch -M "$BRANCH"

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin "$BRANCH"

echo "Pushed to $REMOTE_URL on branch $BRANCH"
