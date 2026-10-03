# Wording micro-tests (Task 9a)

Method (Ruling 13): headless `claude -p` trials run directly from Bash (no subagents), `--max-turns 8`, `--permission-mode default`, `--strict-mcp-config` against tests/stub-mcp.js, allowlist from tests/allowed-tools.txt. Run copies came from tests/prepare-run.sh; the draft SKILL.md plus the repo references/ were copied into `<run>/.claude/skills/token-saver/`. Scored with tests/score.js. Model: claude-opus-5-5. 5 reps per variant per scenario.

Harness fact found here: in these runs the opencode-delegate tools are DEFERRED. init lists them by name only, and agents had to call ToolSearch before using them. The skill was listed in init `skills` in every skill run, but only its description is in context until it is invoked.

## Control (no skill)

- RED reused: D1/D3/K2 0/5 delegation, K1 5/5 kept.
- Sanity check, 2 reps of D1 with the stub: 0/2 (Bash, Bash, Write, Bash; no delegate call).

## Variant A: final body minus the C step-2 wording; the plan's placeholder description

Description: "Use when routine, well-specified coding work (boilerplate, schemas, types, fixtures, docstrings, mechanical refactors) comes up while the opencode-delegate MCP tools are connected, and Claude's context or rate limits are worth preserving."
Step 2: "Run `git diff` and `git status`, and read every changed or new file."
Results: D1 0/5, D3 0/5, K1 5/5, K2 1/5.

- The skill was invoked in 1/20 trials (K2 rep 3), and that trial passed. Agents never loaded the body, so A behaved like the control. Failing final messages read like RED, e.g. D3-1: "I haven't typechecked it or looked at the diff, because both commands were waiting for your approval".
- When the body did load (K2-3) it worked: "Split: JSDoc goes to the delegate; roundCents is billing, so I'll write it myself." The agent called get_delegate_config, then delegate_task with directory=`<run>/src/utils`, then `git status --short && git diff`, then Read.
- Diagnosis: a triggering failure. The description, not the body, is the lever. "worth preserving" leaves room for the agent's judgment to opt out.

## Variant B: A's body; new description

Description: "Use when a request asks for routine, well-specified code of any size (a schema, types, fixtures, docstrings or JSDoc, boilerplate, a mechanical refactor) and opencode-delegate tools such as delegate_task are listed, including as deferred tools."
Results: D1 3/5, D3 5/5, K1 5/5, K2 3/5.

- D1 reps 3 and 5 did delegate and did review, but with `git status --short && cat src/models/user.schema.ts` (Bash cat), neither `git diff` nor Read, so must_follow failed. Both caught the stub's defect: "it dropped `.email()` and added rules nobody asked for".
- K2 reps 1 and 2 never invoked the skill and repeated the RED rationalization: rep 1 "The JSDoc was small enough that handing it off would have taken longer"; rep 2 "Each was only a few lines, and I'd rather not hand money-rounding logic to a cheaper model." Both kept roundCents.
- K1 5/5. The skill was not invoked, and the agent kept auth: "JWT verification is the kind of code where a small mistake lets attackers forge logins, so a delegated draft wasn't worth the risk."

## Variant C (WINNER): B plus two changes

Description: "Use when a request includes routine, well-specified code of any size (...), even alongside other work, and opencode-delegate tools such as delegate_task are listed, including as deferred tools."
Step 2: "Run `git diff` as its own command, then open every new or changed file with Read."
Results: D1 5/5, D3 5/5, K1 5/5, K2 5/5.

- Skill invoked in 15/15 D1/D3/K2 runs and 0/5 K1 runs. Every D1/D3/K2 run followed the same sequence: Skill, ToolSearch, (Read), get_delegate_config, delegate_task, Bash git diff, Read.
- K2: "JSDoc goes to the delegate. roundCents is billing logic, so I'll write that one myself instead of batching it." No K2 delegate `task` mentioned roundCents or round.ts.
- D1: "The delegate wrote the schema but didn't follow the brief. It added `.uuid()` and `.min(1)`, used `coerce.date()`, and left out the email check. I'm fixing it to match the interface."
- D3/K2: the stub always writes user.schema.ts and never touches strings.ts. Agents caught it: "The delegate went off-task: it created an unrelated file and didn't touch `strings.ts`. I'll check that file, then write the JSDoc myself."
- K1: kept every rep. "I wrote it myself rather than handing it off: it's about 25 lines, and it's security code where small slips matter."
- No rep passed auto_approve or a model. The stub reports autoApprove false, so set_delegate_config was never needed.
- `directory` narrowed to src/utils in 4/15 delegations (D3 2/5, K2 2/5, D1 0/5); the rest passed the run root.

Why C won: it is the only variant whose reps converged on all four shapes. D1/D3 delegate and then review; K1 never delegates auth; K2 delegates the JSDoc and keeps roundCents. B's remaining failures had two causes: missed triggering on mixed requests (fixed by "even alongside other work") and an imprecise review step (fixed by "git diff as its own command, then Read"). K1 behaviour was unchanged across all variants.

## Limits

- All micro-tests used the stub server; the 8-turn cap ended most runs early (`error_max_turns`), so many final.md files are empty — verdicts read tool calls and are unaffected.
- The stub's output is always off-task, so "accept good delegate output" was never observed, only "catch a bad one".
- D2, V1, F1 and C1 were not micro-tested; GREEN covers them.
- The K1 keep path was never exercised with the skill body loaded (skill not invoked on K1).
