#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/load-env.sh
source "$ROOT/scripts/lib/load-env.sh" "$ROOT/.env"

WORKSPACES=(lifeos commerceos-dev homeos research sandbox)

echo "Setting up workspaces under $ROOT/workspaces"

for name in "${WORKSPACES[@]}"; do
  dir="$ROOT/workspaces/$name"
  mkdir -p "$dir/scratch"
  readme="$dir/README.md"
  if [[ ! -f "$readme" ]]; then
    cat > "$readme" <<EOF
# Workspace: $name

This folder is isolated for the **$name** profile. Agent edits should stay here.

- \`scratch/\` — disposable drafts and experiments
- Do not store secrets in this tree
- See \`docs/PROJECT_ISOLATION.md\` for cross-profile rules

EOF
    echo "  created README: workspaces/$name"
  else
    echo "  exists: workspaces/$name"
  fi
done

echo "Done."
