#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
patterns=(
  'Build\s*\(func'
  'BuildWith\s*\(func'
  'BuildList\s*\(func'
  'BuildListWith\s*\(func'
)
violations=""
for pattern in "${patterns[@]}"; do
  match=$(rg -P -n "$pattern" factory --glob '!factory/builder_test.go' || true)
  if [[ -n "$match" ]]; then
    violations+="$match"$'\n'
  fi
done
if [[ -n "$violations" ]]; then
  echo "Override policy violation: inline func overrides detected:" >&2
  echo "$violations" >&2
  exit 1
fi
