#!/usr/bin/env bash
# Append manual API spend entry (no secrets, no auto API calls).
# Usage: spend-log.sh <provider> <model> <task_name> <estimated_cost_usd> [notes]
# Example: spend-log.sh deepseek deepseek_flash test-task 0.01 "manual test"

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT/logs/api-spend"
MONTH="$(date -u +%Y-%m 2>/dev/null || date +%Y-%m)"
CSV="$LOG_DIR/${MONTH}.csv"

provider="${1:-}"
model="${2:-}"
task_name="${3:-}"
cost="${4:-}"
notes="${5:-}"

if [[ -z "$provider" || -z "$model" || -z "$task_name" || -z "$cost" ]]; then
  echo "usage: $0 <provider> <model> <task_name> <estimated_cost_usd> [notes]" >&2
  echo "example: $0 deepseek deepseek_flash test-task 0.01 \"manual test\"" >&2
  exit 1
fi

# Sanitize task_name for CSV safety
safe_task="$(echo "$task_name" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9_-' '_' | sed 's/^_\|_$//g')"
if [[ -z "$safe_task" ]]; then
  echo "error: task_name invalid after sanitization" >&2
  exit 1
fi

# Numeric cost validation
if ! [[ "$cost" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "error: estimated_cost_usd must be numeric (e.g. 0.01)" >&2
  exit 1
fi

# Sanitize notes — strip quotes, newlines, common secret patterns
safe_notes="${notes//$'\r'/}"
safe_notes="${safe_notes//$'\n'/ }"
safe_notes="${safe_notes//\"/}"
safe_notes="${safe_notes//\'/}"
if echo "$safe_notes" | grep -qiE 'sk-|api[_-]?key|password|secret|Bearer '; then
  echo "error: notes appear to contain secrets — redact before logging" >&2
  exit 1
fi

# Truncate long notes
if [[ ${#safe_notes} -gt 200 ]]; then
  safe_notes="${safe_notes:0:200}..."
fi

mkdir -p "$LOG_DIR"
DATE="$(date -u +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)"

if [[ ! -f "$CSV" ]]; then
  echo "date,provider,model,task_name,estimated_cost_usd,notes" > "$CSV"
fi

# Escape commas in notes for CSV
csv_notes="${safe_notes//,/;}"
printf '%s,%s,%s,%s,%s,%s\n' "$DATE" "$provider" "$model" "$safe_task" "$cost" "$csv_notes" >> "$CSV"

echo "Logged: $CSV"
echo "  $DATE | $provider | $model | $safe_task | \$$cost | $safe_notes"
