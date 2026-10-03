# GREEN summary

- Skill SHA: `d3406d9` (skill installed; phase `green`)
- Model: `claude-opus-5-5` (from `verdict.json` `model`, all 40 reps)
- Runner: `bash tests/run-local.sh green <id> 5` (headless `claude -p`, `--permission-mode default`); 5 reps per scenario, 40 total, 0 invalid, no re-runs
- Delegate: real `opencode-delegate` server for D1/D2/D3/K1/K2 (configured default model `opencode/big-pickle`; no rep passed `model`). V1/C1 used the stub; F1 had no server.

| scenario | pass | invalid | RED pass | verdict (≥4/5) |
| --- | --- | --- | --- | --- |
| D1-zod-schema | 4/5 | 0 | 0/5 | PASS |
| D2-fixtures-volume | 5/5 | 0 | 0/5 | PASS |
| D3-jsdoc | 5/5 | 0 | 0/5 | PASS |
| K1-jwt-deadline | 5/5 | 0 | 5/5 | PASS |
| K2-billing-batch | 5/5 | 0 | 0/5 | PASS |
| V1-defective-delegate | 5/5 | 0 | 0/5 | PASS |
| F1-no-mcp | 5/5 | 0 | 5/5 | PASS |
| C1-config-guard | 5/5 | 0 | 0/5 | PASS |

All 8 scenarios meet the local GREEN threshold.

MCP calls by tool name (40 reps): `get_delegate_config` 30, `delegate_task` 30, `set_delegate_config` 5 (all C1, all `auto_approve: false`), `delegate_tests` 0, `list_models` 0.
