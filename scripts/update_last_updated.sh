#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
timestamp="${1:-$(date -u '+%Y-%m-%d %H-%M-%S')}"
line="Last updated on ${timestamp}"

files=(
  "README.md"
  "README-zh.md"
  "README-de.md"
  "README-fr.md"
  "README-es.md"
  "README-ja.md"
)

for rel_path in "${files[@]}"; do
  file_path="${repo_root}/${rel_path}"
  tmp_file="$(mktemp)"

  if [[ -f "${file_path}" ]] && head -n 1 "${file_path}" | grep -q '^Last updated on '; then
    {
      printf '%s\n' "${line}"
      tail -n +2 "${file_path}"
    } > "${tmp_file}"
  else
    {
      printf '%s\n\n' "${line}"
      cat "${file_path}"
    } > "${tmp_file}"
  fi

  mv "${tmp_file}" "${file_path}"
done
