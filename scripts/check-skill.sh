#!/usr/bin/env bash
# Lint a skill directory against the token-saver SKILL.md rules.
set -u
DIR=${1:-.}
F="$DIR/SKILL.md"
errs=0
fail() { echo "FAIL: $1"; errs=$((errs+1)); }

[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }
[ "$(head -1 "$F")" = "---" ] || fail "SKILL.md must start with frontmatter"
fm=$(awk 'NR==1{next} /^---$/{exit} {print}' "$F")
body=$(awk 'c>=2{print} /^---$/{c++}' "$F")

[ "${#fm}" -le 1024 ] || fail "frontmatter is ${#fm} chars (max 1024)"
grep -qx 'name: token-saver' <<<"$fm" || fail "name must be token-saver"
desc=$(sed -n 's/^description: *//p' <<<"$fm")
[[ "$desc" == "Use when"* ]] || fail "description must start with 'Use when'"
grep -qi 'automatic' <<<"$desc" && fail "description must not claim automatic triggering"

words=$(wc -w <<<"$body")
[ "$words" -le 500 ] || fail "body is $words words (max 500)"

if grep -qE '\b(opencode|glm|github-copilot|openai|anthropic|minimax[a-z-]*|zai[a-z-]*)/[A-Za-z0-9._-]+' <<<"$body"; then
  fail "body contains a hard-coded model id"
fi

while read -r link; do
  [ -e "$DIR/$link" ] || fail "dead link: $link"
done < <(grep -oE '\]\([^)#]+\)' <<<"$body" | sed -E 's/^\]\(//; s/\)$//' | grep -vE '^[a-z]+:')

[ "$errs" -eq 0 ]
