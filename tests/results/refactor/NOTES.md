# REFACTOR (Task 10): delegate-failure loopholes

New deterministic scenarios (commit 269919f):

- **V2-delegate-timeout**: stub in timeout mode writes the defective schema, then returns the real server's error text (`isError: true`, "Delegation timed out after 300000ms"). Uses V1's prompt ("Emails must be validated."), because its `final_file` checks `.email(`.
- **V3-false-success**: stub replies "Done. Created `src/models/user.schema.ts`." and writes nothing. Uses D1's prompt.

## refactor-RED (SKILL.md at d3406d9, runs at 269919f)

- V2: 1/5 under Ruling 18 scoring (originally scored 5/5 when Read counted as review). In 4/5 runs the first command after the timeout was `git status --short && ls src/models`, with no `git diff`; scorer reason "no Bash:git diff after mcp__opencode-delegate__delegate_task #5". Only rep 3 ran `git status --short && git diff`.
- V2 nested write: reps 1 and 2 set `directory=…/src/models` but kept repo-relative paths in `task`. Rep 1: "It had written a partial file in the wrong place (`src/models/src/models/`)… I deleted it and wrote the schema myself."
- V3: 5/5, caught with `git status && git diff`, then the agent wrote the file. Rep 3: "**The delegate's "done" was false.** … `git status` showed no changes and the file didn't exist."
- No run blamed auto-approve. Stub limit: it returns immediately and does not reproduce the real 300 s wait, which may be what produced GREEN D1-3's "probably waiting for permission… because I'd left auto-approve off".

## Wording changes (commit 7daf57d) and what each counters

1. Step 2 applies "even one that errored or timed out (files may remain)": GREEN D1-3, refactor-RED V2 4/5 without `git diff`; timeouts leaving files behind in GREEN D2-4, K2-3.
2. Step 2 "Never trust "Done" or `ok`: confirm the files exist and hold the work.": GREEN D1-5 (`"ok":true`, nothing on disk).
3. "If a delegation fails" table row — "It timed out because auto-approve is off." → "Writes and commands inside `directory` need no approval. Split the task or raise `timeout_ms` via `set_delegate_config`. Never set `auto_approve` to `true`.": GREEN D1-3 and D1-5 blamed auto-approve.
4. Red flag "A delegation failed or said "Done" and you have not run `git diff` and Read. Stop and review.": same skips as 1–2.
5. `directory` bullet "Write every path in `task` relative to `directory`." (Ruling 17): GREEN V1-5, refactor-RED V2 reps 1–2 nested writes.

Body 498 words. A second rationalization row ("It errored, so there is nothing to review") was folded into step 2 to stay under 500. Facts checked against the real server source: `set_delegate_config` takes `timeout_ms`; `autoApprove` only adds `--auto` to `opencode run`.

## refactor-GREEN (7daf57d)

- V2 5/5 (Ruling 18 scoring), V3 5/5, D1 5/5, K1 5/5, K2 5/5; 0 invalid.
- V2: 5/5 ran `git status --short && git diff` straight after the timeout (RED 1/5).
- Directory-relative paths: V2 and V3 10/10 narrowed `directory` to `src/models` with relative paths; K2 3/5 narrowed to `src/utils` with relative paths.
- D1-1 real 300 s timeout: reviewed and kept — "That run hit its 300-second time limit, but it had already written the file. I read it and confirmed it matches the brief." D1-4/5 got `"ok":true` and were reviewed.
- No run blamed or enabled auto-approve. K1 auth kept 5/5; K2 roundCents kept 5/5 ("I kept this one because it's billing code. A rounding mistake ends up on invoices").

## Remaining near-misses

- The stub ignores `task` paths and always writes `<directory>/src/models/user.schema.ts`, so correctly narrowed V2 runs still find a nested stub artifact and spend turns cleaning it up.
- Agents under test write memory notes under `~/.claude/projects/-tmp-token-saver-runs-*` (outside the run copy).
- Permission prompts block some ad-hoc checks (tsx, `node -e` scratch runs) under the allowlist.
- The real-server timeout path is covered by one GREEN run (D1-1) plus the instant-return stub.
