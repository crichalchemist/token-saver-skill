#!/usr/bin/env bash
# Build an isolated working copy for one eval run.
set -eu
SCEN=$1; WITH_SKILL=$2; RUN=$3
case "$RUN" in /*) ;; *) echo "run dir must be an absolute path: $RUN"; exit 1 ;; esac
ROOT=$(cd "$(dirname "$0")/.." && pwd)
mcp=$(node -e 'const s=require(process.argv[1]);console.log(s.parseScenario(require("fs").readFileSync(process.argv[2],"utf8")).meta.mcp)' "$ROOT/tests/score.js" "$SCEN")

rm -rf "$RUN"; mkdir -p "$RUN"
cp -r "$ROOT/tests/fixture/." "$RUN/"
(cd "$RUN" && npm install --no-audit --no-fund --silent)
printf 'node_modules/\nmcp.json\nPROMPT.md\n.claude/\n' > "$RUN/.gitignore"
(cd "$RUN" && git init -q && git add -A && git -c user.name=eval -c user.email=eval@local commit -qm fixture)

mkdir -p "$RUN/.claude"
printf '{"defaultModel":"opencode/big-pickle","autoApprove":false,"timeoutMs":300000,"profiles":{}}\n' > "$RUN/.claude/opencode-delegate.json"

case "$mcp" in
  real) cat > "$RUN/mcp.json" <<EOF
{"mcpServers":{"opencode-delegate":{"type":"stdio","command":"npx","args":["-y","github:mryesiller/opencode-delegate-mcp#52440fd"],"env":{"NPM_CONFIG_USERCONFIG":"/dev/null","OPENCODE_DELEGATE_CONFIG":"$RUN/.claude/opencode-delegate.json"}}}}
EOF
  ;;
  stub) printf '{"mcpServers":{"opencode-delegate":{"type":"stdio","command":"node","args":["%s/tests/stub-mcp.js"]}}}\n' "$ROOT" > "$RUN/mcp.json" ;;
  stub-unsafe) printf '{"mcpServers":{"opencode-delegate":{"type":"stdio","command":"node","args":["%s/tests/stub-mcp.js"],"env":{"STUB_AUTO_APPROVE":"true"}}}}\n' "$ROOT" > "$RUN/mcp.json" ;;
  stub-timeout) printf '{"mcpServers":{"opencode-delegate":{"type":"stdio","command":"node","args":["%s/tests/stub-mcp.js"],"env":{"STUB_MODE":"timeout"}}}}\n' "$ROOT" > "$RUN/mcp.json" ;;
  stub-false-success) printf '{"mcpServers":{"opencode-delegate":{"type":"stdio","command":"node","args":["%s/tests/stub-mcp.js"],"env":{"STUB_MODE":"false-success"}}}}\n' "$ROOT" > "$RUN/mcp.json" ;;
  none) printf '{"mcpServers":{}}\n' > "$RUN/mcp.json" ;;
esac

if [ "$WITH_SKILL" = 1 ]; then
  mkdir -p "$RUN/.claude/skills/token-saver"
  cp "$ROOT/SKILL.md" "$RUN/.claude/skills/token-saver/"
  cp -r "$ROOT/references" "$RUN/.claude/skills/token-saver/"
fi

node -e 'const s=require(process.argv[1]);process.stdout.write(s.parseScenario(require("fs").readFileSync(process.argv[2],"utf8")).prompt)' "$ROOT/tests/score.js" "$SCEN" > "$RUN/PROMPT.md"
echo "$RUN"
