#!/usr/bin/env bash
# Pick cheapest safe model for a task type using budget-policy routing_order.
# Usage: choose-model-for-task.sh <task-type>
# Types: summary | coding | debug | architecture | commerceos | private | long-context | final-review

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POLICY="$ROOT/configs/budget-policy.example.yaml"
CATALOG="$ROOT/configs/model-catalog.example.yaml"

task="${1:-}"
if [[ -z "$task" ]]; then
  echo "usage: $0 <task-type>" >&2
  echo "types: summary coding debug architecture commerceos private long-context final-review" >&2
  exit 1
fi

# Normalize CLI kebab-case to YAML keys
case "$task" in
  final-review) route_key="final_review" ;;
  long-context) route_key="long-context" ;;
  *) route_key="$task" ;;
esac

get_route_models() {
  local key="$1"
  awk -v key="$key" '
    BEGIN { in_routing=0; in_key=0 }
    /^routing_order:/ { in_routing=1; next }
    in_routing && /^[^[:space:]]/ && !/^routing_order:/ { exit }
    in_routing && $0 ~ "^  " key ": *$" { in_key=1; next }
    in_routing && in_key && /^  [a-z_-]+:/ { exit }
    in_routing && in_key && /^    - / {
      gsub(/^    - /, "")
      gsub(/"/, "")
      print
    }
  ' "$POLICY"
}

mapfile -t ORDER < <(get_route_models "$route_key")
if [[ ${#ORDER[@]} -eq 0 ]]; then
  mapfile -t ORDER < <(get_route_models "default")
fi

if [[ ${#ORDER[@]} -eq 0 ]]; then
  echo "error: no routing_order for task '$task'" >&2
  exit 1
fi

FIRST="${ORDER[0]}"
FALLBACK="${ORDER[1]:-${ORDER[0]}}"
PREMIUM=""
for m in "${ORDER[@]}"; do
  case "$m" in
    gpt_5_mini|claude_sonnet) PREMIUM="$m"; break ;;
  esac
done
if [[ -z "$PREMIUM" ]]; then
  PREMIUM="${ORDER[${#ORDER[@]}-1]}"
fi

needs_approval="no"
case "$route_key" in
  commerceos|final_review|architecture|long-context) needs_approval="yes" ;;
esac

reason="local-first per budget-policy routing_order.${route_key}"
case "$route_key" in
  private) reason="private task — local models only unless user approves online + redaction" ;;
  commerceos) reason="CommerceOS governance — local draft then premium review with approval" ;;
  final_review) reason="final review tier — premium model; explicit approval required" ;;
  coding) reason="coding — start with free local Qwen; escalate if stuck twice" ;;
esac

echo "task:           $task"
echo "first_model:    $FIRST"
echo "fallback_model: $FALLBACK"
echo "premium_model:  $PREMIUM"
echo "approval_needed: $needs_approval"
echo "reason:         $reason"
