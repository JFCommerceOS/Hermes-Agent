#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROUTER="$ROOT/configs/model-router.example.yaml"
LIB="$ROOT/scripts/lib/load-yaml-key.sh"

echo "Hermes Hybrid — routing smoke test"

if [[ ! -x "$LIB" ]] && [[ ! -f "$LIB" ]]; then
  echo "FAIL: missing $LIB"
  exit 1
fi

long_model="$("$LIB" "$ROUTER" "task_routes.long_planning.model")"
arch_model="$("$LIB" "$ROUTER" "task_routes.architecture.model")"
final_model="$("$LIB" "$ROUTER" "task_routes.final_review.model")"
coding_model="$("$LIB" "$ROUTER" "task_routes.coding.model")"

echo "  coding route:        $coding_model"
echo "  long_planning route: $long_model"
echo "  architecture route:  $arch_model"
echo "  final_review route:  $final_model"

err=0
if [[ "$long_model" != "claude_sonnet" ]]; then
  echo "FAIL: long_planning should route to claude_sonnet (online main), got: $long_model"
  err=1
fi
if [[ "$coding_model" != "local_qwen_coder" ]]; then
  echo "FAIL: coding should route to local_qwen_coder, got: $coding_model"
  err=1
fi
if [[ "$final_model" != "claude_sonnet" ]]; then
  echo "FAIL: final_review should route to claude_sonnet, got: $final_model"
  err=1
fi

# choose-model-for-task mapping (CLI hyphen -> yaml underscore)
chosen="$("$ROOT/scripts/choose-model-for-task.sh" final-review 2>/dev/null || true)"
if [[ "$chosen" == "claude_sonnet" ]]; then
  echo "OK: choose-model-for-task final-review -> claude_sonnet"
else
  echo "FAIL: choose-model-for-task final-review expected claude_sonnet, got: $chosen"
  err=1
fi

if [[ $err -eq 0 ]]; then
  echo "OK: hybrid routing rules look correct"
  exit 0
fi
exit 1
