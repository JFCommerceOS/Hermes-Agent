#!/usr/bin/env bash
# Save a verified learning example into profile-scoped memory.
# Usage: save-learning-example.sh <profile> <task_name>
# Example: save-learning-example.sh commerceos-dev sample-task

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VALID_PROFILES=(lifeos commerceos-dev homeos research)

profile="${1:-}"
task_name="${2:-}"

if [[ -z "$profile" || -z "$task_name" ]]; then
  echo "usage: $0 <profile> <task_name>" >&2
  echo "profiles: lifeos | commerceos-dev | homeos | research" >&2
  exit 1
fi

ok=0
for p in "${VALID_PROFILES[@]}"; do
  [[ "$profile" == "$p" ]] && ok=1 && break
done
if [[ $ok -eq 0 ]]; then
  echo "error: unknown profile '$profile'" >&2
  exit 1
fi

# Sanitize task_name for filename
safe_name="$(echo "$task_name" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9-' '-' | sed 's/^-//;s/-$//')"
if [[ -z "$safe_name" ]]; then
  echo "error: task_name invalid after sanitization" >&2
  exit 1
fi

date_dir="$(date -u +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)"
dest_dir="$ROOT/memories/$profile/learning-log/$date_dir"
mkdir -p "$dest_dir"

base="$dest_dir/${safe_name}.md"
out="$base"
n=1
while [[ -e "$out" ]]; do
  out="${dest_dir}/${safe_name}-${n}.md"
  n=$((n + 1))
done

stamp="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%dT%H:%M:%SZ)"

cat > "$out" <<EOF
# Learning Example

Profile: $profile
Task: $task_name
Date: $stamp
Model used: (fill in)
Local model succeeded: (yes/no)
Paid escalation used: (yes/no)
Final solution:

Failed attempts:

Reusable pattern:

Files touched:

Test commands:

Future skill idea:

RAG tag:

Do-not-break rules:

EOF

echo "Saved: $out"
