#!/usr/bin/env bash
# Create per-profile learning/RAG folders (never deletes existing content)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PROFILES=(lifeos commerceos-dev homeos research)
SUBS=(learning-log golden-examples failed-local-cases cursor-prompts sop-patterns rag-ready do-not-ingest)

echo "Setting up learning memory under $ROOT/memories"

cat > "$ROOT/memories/README.md" <<'EOF'
# Learning memories

Per-profile folders — **never mix across LifeOS, commerceos-dev, homeos, research.**

Each profile contains:
- `learning-log/` — dated session entries (`save-learning-example.sh`)
- `golden-examples/` — verified best answers
- `failed-local-cases/` — local misses for escalation tuning
- `cursor-prompts/` — reusable Cursor blocks
- `sop-patterns/` — procedural wins
- `rag-ready/` — cleaned chunks for local RAG ingest
- `do-not-ingest/` — raw/dirty quarantine

See `docs/LOCAL_RAG_STRATEGY.md` and skill `local-learning-loop`.
EOF

for profile in "${PROFILES[@]}"; do
  for sub in "${SUBS[@]}"; do
    dir="$ROOT/memories/$profile/$sub"
    mkdir -p "$dir"
    touch "$dir/.gitkeep"
    echo "  + memories/$profile/$sub/"
  done
  if [[ ! -f "$ROOT/memories/$profile/README.md" ]]; then
    cat > "$ROOT/memories/$profile/README.md" <<EOF
# Memory: $profile

Profile-isolated memory. Use only with matching agent profile under \`workspaces/$profile/\`.

EOF
  fi
done

echo "Learning memory structure ready."
