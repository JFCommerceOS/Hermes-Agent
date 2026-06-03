#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env"

if [[ "${SKIP_LOCAL_MODEL_TEST:-0}" == "1" ]]; then
  echo "SKIP local model test: SKIP_LOCAL_MODEL_TEST=1"
  exit 0
fi

base="${LOCAL_MODEL_BASE_URL:-http://127.0.0.1:11434/v1}"
model="${LOCAL_MODEL_NAME:-qwen2.5-coder:14b}"

# Normalize: Ollama uses /api/tags without /v1
health_base="${base%/v1}"
health_base="${health_base%/}"

echo "Testing local model at $health_base (model: $model)..."

if curl -sf "${health_base}/api/tags" >/dev/null 2>&1; then
  echo "OK: Ollama-compatible endpoint reachable"
  if curl -sf "${health_base}/api/tags" | grep -q "$model" 2>/dev/null; then
    echo "OK: model tag '$model' found in /api/tags"
  else
    echo "WARN: endpoint up but model '$model' not listed — pull with: ollama pull $model"
  fi
  exit 0
fi

# LM Studio OpenAI shim
if curl -sf "${base}/models" >/dev/null 2>&1; then
  echo "OK: OpenAI-compatible /models reachable at $base"
  exit 0
fi

echo "FAIL: cannot reach local model at $base"
echo "Hint: start Ollama or LM Studio, or set SKIP_LOCAL_MODEL_TEST=1 in .env"
exit 1
