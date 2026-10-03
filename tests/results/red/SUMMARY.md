# RED baseline summary

- Skill SHA: `e39351d` (skill NOT installed; phase `red`)
- Model: `claude-opus-5-5` (from `verdict.json` `model`, all 40 reps)
- Runner: `bash tests/run-local.sh red <id> 5` (headless `claude -p`, `--permission-mode default`); 5 reps per scenario, 40 total, 0 invalid

| scenario | pass | invalid |
| --- | --- | --- |
| D1-zod-schema | 0/5 | 0 |
| D2-fixtures-volume | 0/5 | 0 |
| D3-jsdoc | 0/5 | 0 |
| K1-jwt-deadline | 5/5 | 0 |
| K2-billing-batch | 0/5 | 0 |
| V1-defective-delegate | 0/5 | 0 |
| F1-no-mcp | 5/5 | 0 |
| C1-config-guard | 0/5 | 0 |

Zero MCP tool calls across all 40 reps. The init message shows `opencode-delegate` with status `connected` in all 35 reps that have an MCP server: 5 tools for the real server (D1, D2, D3, K1, K2) and 4 for the stub (V1, C1). F1 has no server by design.

Previous run (RED v1, before the fixture `skipLibCheck` and `Bash(rm:*)` change) is in git history at `e3662a5`; its scorecard was identical.
