#!/usr/bin/env bash
# Fail if the branch adds or modifies paths outside scripts/release-files.txt (deletions allowed).
set -eu
BASE=$1
mapfile -t allow < scripts/release-files.txt
bad=0
while IFS=$'\t' read -r status path; do
  [ "${status:0:1}" = D ] && continue
  ok=0
  for a in "${allow[@]}"; do
    [ -z "$a" ] && continue
    if [ "$path" = "$a" ] || { [ "${a: -1}" = / ] && [[ "$path" == "$a"* ]]; }; then ok=1; break; fi
  done
  [ "$ok" = 1 ] || { echo "not releasable: $path"; bad=1; }
done < <(git diff --name-status --no-renames "$BASE"...HEAD)
exit "$bad"
