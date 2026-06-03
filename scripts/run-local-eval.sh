#!/usr/bin/env bash
# Create local evaluation run folder and result template (no paid APIs).
# Usage: run-local-eval.sh [--task E01] [--profile commerceos-dev]
# Optional: probes LOCAL_MODEL_BASE_URL if set and --task given.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env" 2>/dev/null || true

DATE="$(date -u +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)"
EVAL_DIR="$ROOT/evaluations/$DATE"
TASK_FILTER=""
PROFILE="commerceos-dev"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task) TASK_FILTER="${2:-}"; shift 2 ;;
    --profile) PROFILE="${2:-commerceos-dev}"; shift 2 ;;
    *) shift ;;
  esac
done

TASKS=(
  "E01:Explain a function (coding)"
  "E02:Small bug fix suggestion (coding)"
  "E03:Cursor prompt draft (coding)"
  "E04:Refactor plan local draft (coding)"
  "E05:Type hint addition (coding)"
  "E06:Parse error line (debug)"
  "E07:Test failure summary (debug)"
  "E08:Log triage priority (debug)"
  "E09:Stack trace root cause (debug)"
  "E10:Safe rerun command (debug)"
  "E11:Daily plan bullets (planning)"
  "E12:SOP outline (planning)"
  "E13:Risk list secrets online (planning)"
  "E14:Task breakdown (planning)"
  "E15:Weekly review checklist (planning)"
  "E16:Tenant isolation rule (commerceos)"
  "E17:RBAC change review (commerceos)"
  "E18:Audit trail requirement (commerceos)"
  "E19:Model floating note recall (rag)"
  "E20:Profile isolation recall (rag)"
)

mkdir -p "$EVAL_DIR"

echo "=== Hermes local evaluation ==="
echo "Date:    $DATE"
echo "Output:  $EVAL_DIR"
echo "Profile: $PROFILE"
echo "Docs:    docs/LOCAL_MODEL_EVALUATION.md"
echo ""
echo "Tasks (20):"
for t in "${TASKS[@]}"; do
  id="${t%%:*}"
  rest="${t#*:}"
  if [[ -n "$TASK_FILTER" && "$id" != "$TASK_FILTER" ]]; then
    continue
  fi
  echo "  $id — $rest"
done
echo ""

RESULTS="$EVAL_DIR/results.md"
if [[ ! -f "$RESULTS" ]]; then
  cat > "$RESULTS" <<EOF
# Local evaluation results — $DATE

Profile: $PROFILE
Model tested: (fill in — e.g. local_qwen_coder)
RAG enabled: yes | no

| ID | Pass | Notes |
|----|------|-------|
EOF
  for t in "${TASKS[@]}"; do
    id="${t%%:*}"
    echo "| $id | | |" >> "$RESULTS"
  done
  cat >> "$RESULTS" <<EOF

## Summary

- Passed: /20
- Failed:
- Escalated to paid: (should be none during eval script run)

See docs/LOCAL_MODEL_EVALUATION.md for prompts and checklists.
EOF
  echo "Created: $RESULTS"
else
  echo "Exists:  $RESULTS (not overwritten)"
fi

SUMMARY="$EVAL_DIR/summary.md"
if [[ ! -f "$SUMMARY" ]]; then
  cat > "$SUMMARY" <<EOF
# Evaluation summary — $DATE

- **Pass rate:** 
- **Local model:** 
- **Next actions:** 
EOF
  echo "Created: $SUMMARY"
fi

# Optional local probe — never paid APIs
if [[ -n "$TASK_FILTER" ]]; then
  BASE="${LOCAL_MODEL_BASE_URL:-}"
  MODEL="${LOCAL_MODEL_NAME:-}"
  if [[ -z "$BASE" || -z "$MODEL" ]]; then
    echo "SKIP local probe: LOCAL_MODEL_BASE_URL or LOCAL_MODEL_NAME not set in .env"
    exit 0
  fi
  if [[ "${SKIP_LOCAL_MODEL_TEST:-0}" == "1" ]]; then
    echo "SKIP local probe: SKIP_LOCAL_MODEL_TEST=1"
    exit 0
  fi
  echo "Probing local model at $BASE (model: $MODEL)..."
  PROBE="$EVAL_DIR/${TASK_FILTER}-probe.txt"
  if command -v curl >/dev/null 2>&1; then
    if curl -sf --max-time 30 "${BASE%/}/models" >/dev/null 2>&1; then
      echo "  [OK] Local endpoint reachable"
      echo "task: $TASK_FILTER" > "$PROBE"
      echo "endpoint: $BASE" >> "$PROBE"
      echo "model: $MODEL" >> "$PROBE"
      echo "  Wrote probe stub: $PROBE"
      echo "  Run prompt manually from docs/LOCAL_MODEL_EVALUATION.md — no auto prompt (no secrets)."
    else
      echo "  [WARN] Local endpoint not reachable — start Ollama/LM Studio"
      exit 0
    fi
  else
    echo "  [WARN] curl not found — skip probe"
  fi
fi

echo ""
echo "Done. Mark pass/fail in $RESULTS"
