#!/usr/bin/env bash
# Run one scenario N times with headless `claude -p` in fresh working copies and score each run.
set -eu
PHASE=$1; ID=$2; REPS=${3:-5}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SCEN="$ROOT/tests/scenarios/$ID.md"
[ -f "$SCEN" ] || { echo "no scenario $ID"; exit 1; }
case "$PHASE" in red) SKILL=0 ;; green|refactor) SKILL=1 ;; *) echo "phase must be red|green|refactor"; exit 1 ;; esac
SHA=$(git -C "$ROOT" rev-parse --short HEAD)
TOOLS=$(cat "$ROOT/tests/allowed-tools.txt")

for rep in $(seq 1 "$REPS"); do
  RUN="$ROOT/tests/.runs/$PHASE-$ID-$rep"
  OUT="$ROOT/tests/results/$PHASE/$ID/$rep"
  rm -rf "$OUT"; mkdir -p "$OUT"
  bash "$ROOT/tests/prepare-run.sh" "$SCEN" "$SKILL" "$RUN" >/dev/null
  if ! (cd "$RUN" && timeout 900 claude -p "$(cat PROMPT.md)" \
        --output-format stream-json --verbose --max-turns 40 \
        --mcp-config "$RUN/mcp.json" --strict-mcp-config \
        --allowedTools "$TOOLS" < /dev/null > "$OUT/stream.jsonl"); then
    echo "claude exited non-zero" > "$OUT/notes.txt"
  fi
  # stream-json is one message per line; the scorer reads the same array shape as the CI execution log.
  MODEL=$(node -e '
    const fs = require("fs");
    const [src, exec, fin] = process.argv.slice(1);
    const msgs = fs.readFileSync(src, "utf8").split("\n").filter(Boolean).map((l) => JSON.parse(l));
    fs.writeFileSync(exec, JSON.stringify(msgs));
    const r = msgs.find((m) => m.type === "result");
    fs.writeFileSync(fin, (r && r.result) || "");
    const init = msgs.find((m) => m.type === "system" && m.subtype === "init");
    console.log((init && init.model) || "unknown");
  ' "$OUT/stream.jsonl" "$OUT/execution.json" "$OUT/final.md")
  node "$ROOT/tests/score.js" --scenario "$SCEN" --execution "$OUT/execution.json" --run-dir "$RUN" > "$OUT/verdict.tmp" || true
  node -e 'const v=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));v.sha=process.argv[2];v.phase=process.argv[3];v.model=process.argv[4];console.log(JSON.stringify(v,null,2))' "$OUT/verdict.tmp" "$SHA" "$PHASE" "$MODEL" > "$OUT/verdict.json"
  rm "$OUT/verdict.tmp"
  (cd "$RUN" && git diff > "$OUT/run.diff"; git status --short >> "$OUT/run.diff")
  node -e 'const v=require(process.argv[1]);console.log((v.pass?"PASS":"FAIL")+" "+v.id+" rep "+process.argv[2]+(v.pass?"":" :: "+v.reasons.join("; ")))' "$OUT/verdict.json" "$rep"
done
