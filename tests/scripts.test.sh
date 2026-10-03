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
bash "$ROOT/scripts/check-skill.sh" "$T/good" >/dev/null && ok "valid skill passes lint" || bad "valid skill passes lint"

mkskill "$T/desc" "Automatically delegates work" "body"
bash "$ROOT/scripts/check-skill.sh" "$T/desc" >/dev/null && bad "workflow-style description is rejected" || ok "workflow-style description is rejected"

mkskill "$T/long" "Use when x" "$(yes word | head -501 | tr '\n' ' ')"
bash "$ROOT/scripts/check-skill.sh" "$T/long" >/dev/null && bad "body over 500 words is rejected" || ok "body over 500 words is rejected"

mkskill "$T/model" "Use when x" "Call with opencode/big-pickle."
bash "$ROOT/scripts/check-skill.sh" "$T/model" >/dev/null && bad "hard-coded model id is rejected" || ok "hard-coded model id is rejected"

mkskill "$T/link" "Use when x" "See [gone](references/missing.md)."
bash "$ROOT/scripts/check-skill.sh" "$T/link" >/dev/null && bad "dead reference link is rejected" || ok "dead reference link is rejected"

bash "$ROOT/scripts/build-skill.sh" "$T/good" "$T/out.skill" >/dev/null
bash "$ROOT/scripts/build-skill.sh" --check "$T/good" "$T/out.skill" >/dev/null && ok "fresh build is in sync" || bad "fresh build is in sync"
echo changed >> "$T/good/references/setup.md"
bash "$ROOT/scripts/build-skill.sh" --check "$T/good" "$T/out.skill" >/dev/null && bad "edited reference makes build stale" || ok "edited reference makes build stale"

echo "pass=$pass fail=$fail"; [ "$fail" -eq 0 ]
