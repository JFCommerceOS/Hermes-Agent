#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env"

skip_reason=""

if [[ "${ONLINE_MODEL_SKIP:-false}" == "true" ]]; then
  skip_reason="ONLINE_MODEL_SKIP=true"
elif [[ -z "${ONLINE_MODEL_API_KEY:-}" ]]; then
  skip_reason="ONLINE_MODEL_API_KEY empty"
elif [[ "${ONLINE_MODEL_API_KEY}" == *"your-online-api-key"* ]] || [[ "${ONLINE_MODEL_API_KEY}" == *"placeholder"* ]]; then
  skip_reason="placeholder API key"
fi

if [[ -n "$skip_reason" ]]; then
  echo "SKIP online model test: $skip_reason"
  exit 0
fi

provider="${ONLINE_MODEL_PROVIDER:-openrouter}"
model="${ONLINE_MODEL_NAME:-anthropic/claude-sonnet-4}"

echo "Testing online model ($provider / $model)..."

if [[ "$provider" == "openrouter" ]]; then
  url="https://openrouter.ai/api/v1/models"
  http_code="$(curl -sS -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer ${ONLINE_MODEL_API_KEY}" \
    -H "HTTP-Referer: hermes-hybrid-setup" \
    "$url" || echo "000")"
  if [[ "$http_code" == "200" ]]; then
    echo "OK: OpenRouter API reachable (HTTP $http_code)"
    exit 0
  fi
  echo "FAIL: OpenRouter API check HTTP $http_code"
  exit 1
fi

echo "WARN: unknown provider '$provider' — manual verification required"
exit 0
