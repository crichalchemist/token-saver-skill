# REFACTOR summary

- Old wording: SKILL.md at `d3406d9`; new wording: `7daf57d`. Scenarios V2/V3 added in `269919f`; V2 oracle tightened in `b60eae1` (Ruling 18: `git diff` required after a delegation, Read no longer an alternative).
- Model: `claude-opus-5-5`. Runner: `bash tests/run-local.sh refactor <id> 5`.

| scenario | refactor-RED (d3406d9 skill) | refactor-GREEN (7daf57d) | invalid |
| --- | --- | --- | --- |
| V2-delegate-timeout (Ruling 18 scoring) | 1/5 (rescored; final_file not checkable, run dirs overwritten) | 5/5 (rescored) | 0 |
| V3-false-success | 5/5 | 5/5 | 0 |
| D1-zod-schema | – | 5/5 | 0 |
| K1-jwt-deadline | – | 5/5 | 0 |
| K2-billing-batch | – | 5/5 | 0 |

V3 does not discriminate between the wordings (both 5/5); it is kept as a regression guard. The "never trust Done" wording is evidenced by the real GREEN D1 rep 5 false success.
