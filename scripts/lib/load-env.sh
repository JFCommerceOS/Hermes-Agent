#!/usr/bin/env bash
# Safe .env loader for Git Bash on Windows (handles CRLF, comments, quoted values).
# Usage: source "$(dirname "$0")/load-env.sh" [path/to/.env]

_load_env_file() {
  local env_file="${1:-}"
  [[ -n "$env_file" && -f "$env_file" ]] || return 0

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Strip CR (Windows CRLF)
    line="${line//$'\r'/}"
    # Trim leading whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    [[ "$line" =~ ^export[[:space:]] ]] && line="${line#export }"
    line="${line#"${line%%[![:space:]]*}"}"
    [[ "$line" != *"="* ]] && continue

    local key="${line%%=*}"
    local val="${line#*=}"
    key="${key%"${key##*[![:space:]]}"}"
    key="${key#"${key%%[![:space:]]*}"}"

    # Strip surrounding quotes
    if [[ "$val" =~ ^\".*\"$ ]]; then
      val="${val:1:${#val}-2}"
    elif [[ "$val" =~ ^\'.*\'$ ]]; then
      val="${val:1:${#val}-2}"
    fi
    val="${val//$'\r'/}"

    # Only set if not already exported (shell wins)
    if [[ -z "${!key+x}" ]]; then
      export "$key=$val"
    fi
  done < "$env_file"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  _load_env_file "${1:-}"
else
  _SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  _ROOT="$(cd "$_SCRIPT_DIR/../.." && pwd)"
  _load_env_file "${1:-$_ROOT/.env}"
  unset _SCRIPT_DIR _ROOT
fi
