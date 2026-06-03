#!/usr/bin/env bash
# Install bundled skills into a Hermes/Cursor skills directory.
# Usage: install-skills.sh [TARGET_SKILLS_DIR]

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/skills"
TARGET="${1:-${HERMES_SKILLS_DIR:-$HOME/.cursor/skills-cursor}}"

if [[ ! -d "$SRC" ]]; then
  echo "error: skills source missing: $SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"
count=0

for skill_dir in "$SRC"/*/; do
  [[ -d "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    echo "skip (no SKILL.md): $name"
    continue
  fi
  dest="$TARGET/$name"
  mkdir -p "$dest"
  cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
  echo "  installed: $name"
  count=$((count + 1))
done

echo "Installed $count skills to $TARGET"
