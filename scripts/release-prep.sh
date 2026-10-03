#!/usr/bin/env bash
# Cut release/<version> from dev with only releasable paths.
set -eu
V=$1
if ! git diff --quiet || ! git diff --cached --quiet; then echo "working tree not clean"; exit 1; fi
git fetch -q origin
git switch -c "release/$V" origin/dev
mapfile -t allow < scripts/release-files.txt
git ls-files | while read -r f; do
  keep=0
  for a in "${allow[@]}"; do
    [ -z "$a" ] && continue
    if [ "$f" = "$a" ] || { [ "${a: -1}" = / ] && [[ "$f" == "$a"* ]]; }; then keep=1; break; fi
  done
  [ "$keep" = 1 ] || git rm -q --cached -r -- "$f"
done
bash scripts/build-skill.sh
git add token-saver.skill
git commit -m "Release $V"
bash scripts/release-guard.sh origin/main
echo "release/$V ready; push and open a PR to main"
