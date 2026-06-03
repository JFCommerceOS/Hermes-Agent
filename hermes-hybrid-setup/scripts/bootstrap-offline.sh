#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== Hermes Hybrid — offline bootstrap ==="
echo

run() {
  echo ">> $*"
  bash "$@"
  echo
}

run "$ROOT/scripts/setup-workspaces.sh"
run "$ROOT/scripts/setup-learning-memory.sh"
run "$ROOT/scripts/check-environment.sh"
run "$ROOT/scripts/test-hybrid-routing.sh"

echo ">> Skipping online model test (offline bootstrap)"
bash "$ROOT/scripts/test-online-model.sh" || true

if [[ "${SKIP_LOCAL_MODEL_TEST:-0}" != "1" ]]; then
  echo ">> Optional local model test"
  bash "$ROOT/scripts/test-local-model.sh" || note=$?
  if [[ "${note:-0}" -ne 0 ]]; then
    echo "WARN: local model test failed — set SKIP_LOCAL_MODEL_TEST=1 if Ollama is not running"
  fi
else
  bash "$ROOT/scripts/test-local-model.sh"
fi

echo "=== Bootstrap complete ==="
