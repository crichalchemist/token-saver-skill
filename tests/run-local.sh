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
  RUN="${TOKEN_SAVER_RUNS:-${TMPDIR:-/tmp}/token-saver-runs}/$PHASE-$ID-$rep"
  OUT="$ROOT/tests/results/$PHASE/$ID/$rep"
  rm -rf "$OUT"; mkdir -p "$OUT"
  bash "$ROOT/tests/prepare-run.sh" "$SCEN" "$SKILL" "$RUN" >/dev/null
  if ! (cd "$RUN" && timeout 900 claude -p "$(cat PROMPT.md)" \
        --output-format stream-json --verbose --max-turns 40 \
        --permission-mode default \
        --mcp-config "$RUN/mcp.json" --strict-mcp-config \
        --allowedTools "$TOOLS" < /dev/null > "$OUT/stream.jsonl"); then
    echo "claude exited non-zero" > "$OUT/notes.txt"
  fi
  # stream-json is one message per line; the scorer reads the same array shape as the CI execution log.
  MODEL=$(node -e '
    const fs = require("fs");
    const [src, exec, fin, notes] = process.argv.slice(1);
    const lines = fs.readFileSync(src, "utf8").split("\n").filter(Boolean);
    const msgs = lines.map((l) => { try { return JSON.parse(l); } catch { return null; } }).filter(Boolean);
    if (msgs.length < lines.length) fs.appendFileSync(process.argv[4], (lines.length - msgs.length) + " unparseable stream line(s)\n");
    fs.writeFileSync(exec, JSON.stringify(msgs));
    const r = msgs.find((m) => m.type === "result");
    fs.writeFileSync(fin, (r && r.result) || "");
    const init = msgs.find((m) => m.type === "system" && m.subtype === "init");
    console.log((init && init.model) || "unknown");
  ' "$OUT/stream.jsonl" "$OUT/execution.json" "$OUT/final.md" "$OUT/notes.txt")
  node "$ROOT/tests/score.js" --scenario "$SCEN" --execution "$OUT/execution.json" --run-dir "$RUN" > "$OUT/verdict.tmp" || true
  node -e '
    const fs = require("fs");
    const [tmp, sha, phase, model, exec, notes] = process.argv.slice(1);
    const v = JSON.parse(fs.readFileSync(tmp, "utf8"));
    Object.assign(v, { sha, phase, model });
    const invalid = [];
    if (!JSON.parse(fs.readFileSync(exec, "utf8")).some((m) => m.type === "result")) invalid.push("no result message");
    if (v.calls.length === 0) invalid.push("zero tool calls");
    if (fs.existsSync(notes)) invalid.push(fs.readFileSync(notes, "utf8").trim());
    if (invalid.length) { v.pass = false; v.invalid = true; v.reasons = ["INVALID RUN: " + invalid.join("; "), ...v.reasons]; }
    console.log(JSON.stringify(v, null, 2));
  ' "$OUT/verdict.tmp" "$SHA" "$PHASE" "$MODEL" "$OUT/execution.json" "$OUT/notes.txt" > "$OUT/verdict.json"
  rm "$OUT/verdict.tmp"
  (cd "$RUN" && git diff > "$OUT/run.diff"; git status --short >> "$OUT/run.diff")
  node -e 'const v=require(process.argv[1]);console.log((v.pass?"PASS":"FAIL")+" "+v.id+" rep "+process.argv[2]+(v.pass?"":" :: "+v.reasons.join("; ")))' "$OUT/verdict.json" "$rep"
done
