#!/usr/bin/env bash
# Print model catalog notes from configs/model-catalog.example.yaml
# Usage: show-model-notes.sh [model_id|all]

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATALOG="$ROOT/configs/model-catalog.example.yaml"
filter="${1:-all}"

if [[ ! -f "$CATALOG" ]]; then
  echo "error: missing $CATALOG" >&2
  exit 1
fi

print_model() {
  local id="$1"
  local cost privacy note best_for escalate

  cost=$(awk -v id="$id" '
    $0 ~ "^  " id ":$" { f=1; next }
    f && /^  [a-z_]/ { exit }
    f && /^    cost_level:/ { print $2; exit }
  ' "$CATALOG")

  privacy=$(awk -v id="$id" '
    $0 ~ "^  " id ":$" { f=1; next }
    f && /^  [a-z_]/ { exit }
    f && /^    privacy:/ { print $2; exit }
  ' "$CATALOG")

  note=$(awk -v id="$id" '
    $0 ~ "^  " id ":$" { f=1; next }
    f && /^  [a-z_]/ { exit }
    f && /^    floating_note:/ {
      sub(/^    floating_note: "/,""); sub(/"$/,""); print; exit
    }
  ' "$CATALOG")

  best_for=$(awk -v id="$id" '
    $0 ~ "^  " id ":$" { f=1; next }
    f && /^  [a-z_]/ { exit }
    f && /^    best_for:/ { bf=1; next }
    bf && /^    weak_for:/ { exit }
    bf && /^      - / { sub(/^      - /,""); printf "%s; ", $0 }
  ' "$CATALOG")

  escalate=$(awk -v id="$id" '
    $0 ~ "^  " id ":$" { f=1; next }
    f && /^  [a-z_]/ { exit }
    f && /^    escalation:/ { es=1; next }
    es && /^    floating_note:/ { exit }
    es && /^      - / { sub(/^      - /,""); printf "%s, ", $0 }
  ' "$CATALOG")
  escalate="${escalate%, }"
  [[ -z "$escalate" ]] && escalate="none"

  echo "=== $id ==="
  echo "cost_level:     ${cost:-unknown}"
  echo "privacy:        ${privacy:-unknown}"
  echo "best_for:       ${best_for:-see catalog}"
  echo "when_escalate:  $escalate"
  echo "floating_note:  ${note:-(none)}"
  echo
}

if [[ "$filter" == "all" ]]; then
  ids=$(grep -E '^  [a-z_0-9]+:$' "$CATALOG" | tr -d ' :')
  for id in $ids; do
    print_model "$id"
  done
else
  print_model "$filter"
fi
