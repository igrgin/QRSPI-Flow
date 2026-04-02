#!/usr/bin/env bash
set -euo pipefail

# Context-efficient command runner:
# - if command succeeds: print a single check line
# - if command fails: print failure line + full captured output

run_silent() {
  local description="$1"
  local command="$2"
  local tmp_file
  tmp_file=$(mktemp)

  if eval "$command" >"$tmp_file" 2>&1; then
    printf "✓ %s\n" "$description"
    rm -f "$tmp_file"
    return 0
  else
    local exit_code=$?
    printf "✗ %s\n" "$description"
    cat "$tmp_file"
    rm -f "$tmp_file"
    return "$exit_code"
  fi
}

# Example:
# run_silent "Unit tests" "npm test"
