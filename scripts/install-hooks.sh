#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cp "$ROOT_DIR/hooks/pre-commit.sample" "$ROOT_DIR/.git/hooks/pre-commit"
cp "$ROOT_DIR/hooks/pre-push.sample" "$ROOT_DIR/.git/hooks/pre-push"
chmod +x "$ROOT_DIR/.git/hooks/pre-commit" "$ROOT_DIR/.git/hooks/pre-push"

echo "Installed pre-commit and pre-push hooks."
