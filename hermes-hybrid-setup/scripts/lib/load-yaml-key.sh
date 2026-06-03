#!/usr/bin/env bash
# Minimal YAML value extractor (no yq dependency). Supports dotted paths for nested keys.
# Usage: load-yaml-key.sh <file.yaml> <dotted.key>
# Example: load-yaml-key.sh configs/model-router.example.yaml task_routes.long_planning.model

set -euo pipefail

yaml_file="${1:?yaml file required}"
key_path="${2:?dotted key required}"

if [[ ! -f "$yaml_file" ]]; then
  echo "error: file not found: $yaml_file" >&2
  exit 1
fi

IFS='.' read -ra PARTS <<< "$key_path"
target_key="${PARTS[-1]}"
depth="${#PARTS[@]}"

# Walk file: track indent stack for nested sections
declare -a section_stack=()
found=0
value=""

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line//$'\r'/}"
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// }" ]] && continue

  if [[ ! "$line" =~ ^([[:space:]]*) ]]; then
    continue
  fi
  indent="${BASH_REMATCH[1]}"
  indent_len="${#indent}"
  content="${line#"${indent}"}"

  # Pop stack to current indent level (2 spaces per level assumed)
  level=$((indent_len / 2))
  while ((${#section_stack[@]} > level)); do
    unset 'section_stack[-1]'
  done

  if [[ "$content" =~ ^([^:]+):[[:space:]]*(.*)$ ]]; then
    k="${BASH_REMATCH[1]}"
    rest="${BASH_REMATCH[2]}"
    k="${k#"${k%%[![:space:]]*}"}"
    k="${k%"${k##*[![:space:]]}"}"

    if ((${#section_stack[@]} < level)); then
      section_stack+=("$k")
    else
      section_stack[$level]="$k"
    fi

    # Match path
    if ((${#section_stack[@]} == depth)); then
      match=1
      for ((i=0; i<depth; i++)); do
        if [[ "${section_stack[$i]}" != "${PARTS[$i]}" ]]; then
          match=0
          break
        fi
      done
      if [[ $match -eq 1 && "$k" == "$target_key" ]]; then
        value="${rest}"
        value="${value#\"}"
        value="${value%\"}"
        value="${value#\'}"
        value="${value%\'}"
        found=1
        break
      fi
    fi
  fi
done < "$yaml_file"

if [[ $found -eq 0 ]]; then
  echo "error: key not found: $key_path in $yaml_file" >&2
  exit 1
fi

printf '%s\n' "$value"
