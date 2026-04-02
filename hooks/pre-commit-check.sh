#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f artifacts/plan.md ]]; then
  echo "[pre-commit-check] artifacts/plan.md is required before commit." >&2
  exit 1
fi

if [[ ! -f artifacts/implementation-log.md ]]; then
  echo "[pre-commit-check] artifacts/implementation-log.md missing (warning)." >&2
  exit 0
fi

if ! rg -n "(test|lint|build|check)" artifacts/implementation-log.md >/dev/null 2>&1; then
  echo "[pre-commit-check] no evidence of verification commands in artifacts/implementation-log.md" >&2
  echo "[pre-commit-check] warning only" >&2
fi

echo "[pre-commit-check] pass"
