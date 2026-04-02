#!/usr/bin/env bash
set -euo pipefail

missing=0
for f in artifacts/research.md artifacts/spec.md artifacts/plan.md; do
  if [[ ! -f "$f" ]]; then
    echo "[phase-gate] missing required artifact: $f" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  echo "[phase-gate] block: complete Q/R/S/P artifacts before implementation." >&2
  exit 1
fi

echo "[phase-gate] pass"
