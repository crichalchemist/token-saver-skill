#!/usr/bin/env bash
# Tests for scripts/*.sh. Each case builds a throwaway skill dir.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   - $1"; }
bad() { fail=$((fail+1)); echo "FAIL - $1"; }

mkskill() { # $1=dir $2=description $3=body
  mkdir -p "$1/references"
  printf -- '---\nname: token-saver\ndescription: %s\n---\n\n%s\n' "$2" "$3" > "$1/SKILL.md"
  echo "ref" > "$1/references/setup.md"
}

T=$(mktemp -d); trap 'rm -rf "$T"' EXIT

mkskill "$T/good" "Use when routine work fits a delegate" "See [setup](references/setup.md)."
if bash "$ROOT/scripts/check-skill.sh" "$T/good" >/dev/null; then ok "valid skill passes lint"; else bad "valid skill passes lint"; fi

mkskill "$T/desc" "Automatically delegates work" "body"
if bash "$ROOT/scripts/check-skill.sh" "$T/desc" >/dev/null; then bad "workflow-style description is rejected"; else ok "workflow-style description is rejected"; fi

mkskill "$T/long" "Use when x" "$(yes word | head -501 | tr '\n' ' ')"
if bash "$ROOT/scripts/check-skill.sh" "$T/long" >/dev/null; then bad "body over 500 words is rejected"; else ok "body over 500 words is rejected"; fi

mkskill "$T/model" "Use when x" "Call with opencode/big-pickle."
if bash "$ROOT/scripts/check-skill.sh" "$T/model" >/dev/null; then bad "hard-coded model id is rejected"; else ok "hard-coded model id is rejected"; fi

mkskill "$T/link" "Use when x" "See [gone](references/missing.md)."
if bash "$ROOT/scripts/check-skill.sh" "$T/link" >/dev/null; then bad "dead reference link is rejected"; else ok "dead reference link is rejected"; fi

bash "$ROOT/scripts/build-skill.sh" "$T/good" "$T/out.skill" >/dev/null
if bash "$ROOT/scripts/build-skill.sh" --check "$T/good" "$T/out.skill" >/dev/null; then ok "fresh build is in sync"; else bad "fresh build is in sync"; fi
echo changed >> "$T/good/references/setup.md"
if bash "$ROOT/scripts/build-skill.sh" --check "$T/good" "$T/out.skill" >/dev/null; then bad "edited reference makes build stale"; else ok "edited reference makes build stale"; fi

echo "pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
