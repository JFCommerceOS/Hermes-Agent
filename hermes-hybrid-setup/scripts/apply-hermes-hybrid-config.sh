#!/usr/bin/env bash
# Materialize example configs into a target Hermes home (no CommerceOS links).
# Usage: apply-hermes-hybrid-config.sh [TARGET_DIR]

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env"

TARGET="${1:-${HERMES_HOME:-$HOME/.hermes-hybrid}}"
mkdir -p "$TARGET/configs"

echo "Applying Hermes hybrid example configs to: $TARGET"

for f in hermes.main model-router safety-policy project-profiles model-catalog budget-policy; do
  src="$ROOT/configs/${f}.example.yaml"
  dst="$TARGET/configs/${f}.yaml"
  cp "$src" "$dst"
  echo "  copied ${f}.yaml"
done

if [[ -f "$ROOT/.env" ]]; then
  grep -E '^(ONLINE_|LOCAL_|ALLOW_|HERMES_|DEFAULT_|ENABLE_|SKIP_)' "$ROOT/.env" \
    | sed 's/\r$//' > "$TARGET/hybrid.env.snippet" || true
  echo "  wrote hybrid.env.snippet (merge manually into Hermes .env)"
fi

echo "Done. See docs/MODEL_SETUP.md for Hermes CLI integration."
