#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env"

pass=0
warn=0
fail=0

ok()   { echo "  [OK]   $*"; pass=$((pass + 1)); }
note() { echo "  [WARN] $*"; warn=$((warn + 1)); }
bad()  { echo "  [FAIL] $*"; fail=$((fail + 1)); }

echo "Hermes Hybrid — environment check"
echo "Root: $ROOT"
echo

# Git Bash / bash
if command -v bash >/dev/null 2>&1; then
  ok "bash: $(bash --version | head -1)"
else
  bad "bash not found — use Git Bash"
fi

# Optional WSL2
if command -v wsl.exe >/dev/null 2>&1; then
  wsl_ver="$(wsl.exe --status 2>/dev/null | head -1 || true)"
  if [[ -n "$wsl_ver" ]]; then
    ok "WSL available (optional): $wsl_ver"
  else
    note "wsl.exe present but status unavailable — WSL2 optional"
  fi
else
  note "WSL not detected — OK for Git-Bash-only workflow"
fi

# Docker (optional sandbox)
if [[ "${ENABLE_DOCKER_SANDBOX:-false}" == "true" ]]; then
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    ok "Docker daemon reachable"
  else
    note "ENABLE_DOCKER_SANDBOX=true but Docker not running — start Docker Desktop or set false"
  fi
else
  note "Docker sandbox disabled (ENABLE_DOCKER_SANDBOX != true)"
fi

# Workspace root
ws="${HERMES_WORKSPACE_ROOT:-$ROOT}"
if [[ -d "$ws" ]]; then
  ok "HERMES_WORKSPACE_ROOT exists: $ws"
else
  bad "HERMES_WORKSPACE_ROOT missing: $ws"
fi

# Safety gates
for gate in ALLOW_GIT_PUSH ALLOW_PRODUCTION_DB ALLOW_DESTRUCTIVE_COMMANDS; do
  val="${!gate:-unset}"
  if [[ "$val" == "false" || "$val" == "0" ]]; then
    ok "$gate=$val (safe default)"
  elif [[ "$val" == "true" || "$val" == "1" ]]; then
    note "$gate=$val — elevated risk; confirm intentional"
  else
    note "$gate not set — treating as restrictive"
  fi
done

# Config files
for f in model-catalog model-router safety-policy project-profiles budget-policy; do
  if [[ -f "$ROOT/configs/${f}.example.yaml" ]]; then
    ok "config present: ${f}.example.yaml"
  else
    bad "missing config: ${f}.example.yaml"
  fi
done

# Active profile
profile="${DEFAULT_PROJECT_PROFILE:-commerceos-dev-agent}"
if [[ -f "$ROOT/ACTIVE_PROFILE" ]]; then
  profile="$(tr -d '\r\n' < "$ROOT/ACTIVE_PROFILE" | head -1)"
fi
ok "active profile: $profile"

echo
echo "Summary: $pass passed, $warn warnings, $fail failed"
[[ $fail -eq 0 ]]
