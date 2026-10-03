#!/usr/bin/env bash
# Build token-saver.skill (zip of SKILL.md + references/) or verify it is in sync.
set -eu
CHECK=0
if [ "${1:-}" = "--check" ]; then CHECK=1; shift; fi
SRC=${1:-.}
OUT=${2:-token-saver.skill}

if [ "$CHECK" -eq 1 ]; then
  [ -f "$OUT" ] || { echo "FAIL: $OUT missing"; exit 1; }
  want=$(cd "$SRC" && find SKILL.md references -type f | sort | sed 's#^#token-saver/#')
  have=$(unzip -Z1 "$OUT" | grep -v '/$' | sort)
  [ "$want" = "$have" ] || { echo "FAIL: file list differs"; exit 1; }
  while read -r f; do
    unzip -p "$OUT" "token-saver/$f" | cmp -s - "$SRC/$f" || { echo "FAIL: stale $f"; exit 1; }
  done < <(cd "$SRC" && find SKILL.md references -type f | sort)
  echo "in sync"
  exit 0
fi

STAGE=$(mktemp -d); trap 'rm -rf "$STAGE"' EXIT
mkdir "$STAGE/token-saver"
cp "$SRC/SKILL.md" "$STAGE/token-saver/"
cp -r "$SRC/references" "$STAGE/token-saver/"
OUT_ABS=$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")
rm -f "$OUT_ABS"
(cd "$STAGE" && zip -qrX "$OUT_ABS" token-saver)
echo "built $OUT"
