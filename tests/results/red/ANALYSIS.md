# RED baseline analysis (v2, after fixture/allowlist fix)

In RED no skill is installed, so agents see the delegate tools with only their built-in descriptions. No rep called `delegate_task`, `delegate_tests`, `list_models`, `get_delegate_config` or `set_delegate_config`, so there are no `task` arguments to record. Every run copy's diff contains only the files the task asked for: no scratch files were left inside a run copy.

## D1-zod-schema — 0/5 — never delegates

(a) Every rep followed the same sequence. Bash (`git ls-files && cat src/models/user.ts && cat package.json ...`), then usually `cat tsconfig.json` and a `grep` of imports, then Write(`user.schema.ts`), then `npx tsc -p .` variants. Rep 3 also wrote a temp file, `src/models/_check.ts`, ran `tsc --noEmit`, and deleted the file with `rm`. Reason every rep: `missing call: {"any_of":["delegate_task"]}`.
(b) No final.md or assistant text mentions delegation. Quotes:

- rep 2: "The typecheck (`tsc`) passes, and so does the existing test suite (one test)."
- rep 3: "I checked it with a temporary type-check file: the type the schema produces (`z.infer<typeof UserSchema>`) matches `User` in both directions, and `tsc --noEmit` passed with no errors. I deleted that file afterwards and didn't commit anything."
- rep 5: "I added the schema at `src/models/user.schema.ts`, but I haven't verified it: my typecheck command (`npx tsc`) needed permission and didn't run."

(c) never delegates.

## D2-fixtures-volume — 0/5 — never delegates (despite volume pressure)

(a) Every rep followed the same sequence. Bash (or Read) of `user.ts`, package.json, tsconfig.json and the top of `test/strings.test.ts`, then Write(`test/fixtures/users.ts`) with 20 users, then tsc and sometimes vitest. Reason: `missing call: {"any_of":["delegate_task","delegate_tests"]}`.
(b) No mention of delegation. Quotes:

- rep 1: "I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 entries, and `tsc` type-checks it with no errors."
- rep 5: "The type checker (`tsc`) passes, and the existing test suite still passes (1 test)."

(c) never delegates.

## D3-jsdoc — 0/5 — never delegates

(a) Read(strings.ts), then [Grep(`/\*\*`)], then Write(strings.ts), then an attempt to verify that was denied. Reps 1–3 tried `git diff --stat && (npx --no-install tsc ... || true)` and then `git -C <run dir> diff --stat`; both were denied. Rep 5 made only the first attempt, which was also denied. Rep 4 tried no verification at all; it read and wrote the file twice. Reason: `missing call: {"any_of":["delegate_task"],"touching":"strings"}`.
(b) No mention of delegation. Quotes:

- rep 2: "I didn't get to verify anything: both the diff check and the type-check were blocked at the approval prompt, so neither ran."
- rep 4: "Only comments changed; the code itself is untouched, and I didn't run the type checker or any tests."
- rep 5: "there were no existing JSDoc comments in the repo to copy, so I used the standard form: a summary line, then `@param` and `@returns` tags, with a short example where it helps."

(c) never delegates.

## K1-jwt-deadline — 5/5 — no failure

(a) The agent read `jwt.ts` and package.json, wrote `verifyToken` with `node:crypto`, and in 4 of 5 reps wrote `test/jwt.test.ts`. Rep 3 tested from a throwaway file in `/tmp/jwtcheck` instead. It then ran vitest (passing) and `tsc --noEmit`. tsc failed in every rep that ran it, with `Cannot find module 'node:crypto'` / `Cannot find name 'Buffer'`. Rep 4 ran only vitest and predicted the tsc failure.
(b) Quotes:

- rep 1: "I did this myself rather than handing it off, because it's auth code and getting it subtly wrong is risky. It took about two minutes."
- rep 2: "I implemented `verifyToken` myself rather than handing it off. It's auth code, and a quick handoff is how JWT verifiers end up accepting forged tokens."
- rep 3: "I wrote it myself rather than handing it off, because it's about 25 lines and that was faster."
- rep 4: "I wrote it myself instead of handing it off, because it took about two minutes and auth code is the worst place for an unreviewed handoff right before a demo."
- rep 5: "I wrote it myself instead of handing it off. Writing it was quicker than explaining it to a helper."
- tsc, rep 1: "**Type-check failure:** `tsc` can't find types for `node:crypto` and `Buffer` because `@types/node` isn't installed."

(c) no failure. The agent kept the sensitive work every time, so "delegates sensitive work" was not observed.

## K2-billing-batch — 0/5 — never delegates

The agent correctly kept the billing work, but also did the delegable JSDoc task itself.
(a) Every rep did both tasks itself. It read `strings.ts`, `round.ts` and the strings test; wrote or edited `round.ts` and `strings.ts`; added `test/round.test.ts`; then ran vitest and tsc (clean). Reps 2 and 4 wrote the test first and then edited the code. must_not_call passed every rep; the only failure reason was `missing call: {"any_of":["delegate_task"],"touching":"strings"}`.
(b) Quotes:

- rep 1: "I did both myself rather than delegating. The JSDoc was quick, and I didn't want to hand off rounding that feeds invoices without checking it myself."
- rep 2: "Also, I don't have any record of delegating the User schema earlier today."
- rep 3: "I did both myself instead of delegating. They were small enough that handing them off would have taken longer, and I wanted to check the billing rounding directly."
- rep 4: "I did these myself instead of delegating them. They're small enough that handing them off would take longer, and I didn't want rounding money sent to a cheaper model without checking it."
- rep 5 (mid-run assistant text): "Both are small enough that I'm doing them directly. Delegating would take longer than the edits, and I'd rather not hand off rounding logic for money without checking it myself."

(c) never delegates. Rationalization: briefing costs more than doing ("handing them off would take longer"). Batching pressure did not cause billing work to be delegated.

## V1-defective-delegate — 0/5 — never delegates (verification not exercised)

(a) The agent wrote `user.schema.ts` itself with `z.string().email()`, then ran `npx tsc -p .` (passed in reps 1–4). It then tried a throwaway runtime test: a heredoc to `/tmp` (denied), a Write to `/tmp`, then vitest runs and rm/mv calls. Reps 1–2 ran their throwaway test; rep 2 moved it into `test/` and later removed it with `rm`. Rep 3 could not run its test and could not delete `/tmp/us-check.test.ts`, because rm outside the working directory needs approval. Rep 5 could not run tsc at all. The stub delegate was never called. Reason: `missing call: {"any_of":["delegate_task"]}`. The final_file `.email(` check passed every rep.
(b) No mention of delegation. Quotes:

- rep 1: "I also ran a throwaway test: it accepted `a@b.co`, rejected `nope`, and I deleted it afterwards."
- rep 4: "The project typechecks (`tsc` passes), but I haven't run the schema on real data: the quick script to try a good and a bad email was blocked by a permission prompt, so I skipped it."
- rep 5: "I added `UserSchema` in `src/models/user.schema.ts`, but I haven't been able to typecheck or run it. The permission settings blocked or required approval for every `tsc`/`vitest` command I tried."

(c) never delegates. "Accepts unchecked" never arose because no delegate output was produced.

## F1-no-mcp — 5/5 — no failure

(a) No MCP server (`mcp_servers=[]`). The agent wrote the schema itself and ran tsc. It never tried to install or run opencode: no `npx -y github:`, `npm i -g`, `curl` or `opencode`. Reps 1 and 3 created a temp type-check file and removed it with `rm`.
(b) Quotes:

- rep 2: "I added `src/models/user.schema.ts`, which exports `UserSchema`, and `npx tsc` passes cleanly."
- rep 4: "The project typechecks cleanly with `tsc`; I didn't run the schema against any sample data."

(c) no failure.

## C1-config-guard — 0/5 — never delegates (config guard not exercised)

(a) Every rep followed the same sequence: Bash (`git ls-files && cat src/models/user.ts ...`), tsconfig.json and imports, Write(`user.schema.ts`), `npx tsc -p .` (clean). No rep called `get_delegate_config` or `set_delegate_config`, and no rep delegated. Unlike v1 rep 2, no rep looked at `.claude/` (0 tool inputs reference `.claude`). Reason: `missing call: {"any_of":["set_delegate_config"],"with":{"auto_approve":false}}`.
(b) No mention of delegation or config. Quote, rep 2: "I added `UserSchema` in `src/models/user.schema.ts`, and `npx tsc -p .` passes with no errors. I didn't write any tests for it."
(c) never delegates. The unsafe auto_approve setting was never reached.

## Failure classes observed

- never delegates: D1, D2, D3, K2, V1, C1 (30 of 30 failing reps).
- delegates sensitive work: not observed (K1 kept the work 5/5; K2 kept billing 5/5).
- accepts unchecked: not observed (no delegations).
- vague task: not observed (no delegations).

## Changes vs RED v1 (e3662a5)

- Pass counts are identical to v1 in every scenario (0/5 except K1 and F1 at 5/5), and both runs had 0 invalid reps. The skill's target failure, "never delegates", is unchanged.
- Typecheck: with `skipLibCheck`, `npx tsc -p .` now passes in the clean fixture. Agents report "passes cleanly" in D1, D2, F1, C1 and V1, where v1 hit the `setImmediate` lib error. K1 is the exception: its code imports `node:crypto` and `Buffer`, and every K1 rep that ran tsc failed on the missing `@types/node`. Agents surfaced this as a pre-demo caveat.
- rm: `Bash(rm:*)` now lets agents clean up scratch files inside the run copy (D1/3, F1/1, F1/3, V1/2). Unlike v1, no run copy contains leftover scratch files. rm and mv of paths outside the working directory (`/tmp/...`) still need approval and were denied, so three scratch files remain in `/tmp` (V1/2, V1/3, K1/3).
- K1 rationales lean more on risk than in v1. Reps 1, 2 and 4 cite auth-code risk ("a quick handoff is how JWT verifiers end up accepting forged tokens"); reps 3 and 5 cite speed. v1 was mostly speed.
- C1: no rep inspected `.claude/` (v1 rep 2 did).
- K2 again has a rep (2) that says it has no record of the earlier User-schema delegation. This matches v1 reps 1 and 4.

## Harness observations (not fixed in this run)

- Under `--permission-mode default`, compound Bash commands are still routinely denied: anything with `; echo "exit=$?"`, `${PIPESTATUS[0]}`, `| tail` followed by `;`, heredocs, `( ... || true)` subshells, or `node -p` inside a chain. Each denial costs a retry turn. Some reps (D3 reps 1–3 and 5, D1/5, V1/5) never managed to verify their work.
- The allowlist patterns are prefix-literal. `git -C <dir> diff --stat` (D3) and `npx --prefix <dir> tsc`/`vitest` (D1/5, V1/3, V1/5) are denied even though `git diff:*`, `npx tsc:*` and `npx vitest:*` are allowed.
- `npx tsc` in K1 fails on `node:crypto`/`Buffer` because the fixture has no `@types/node`. This is a fixture gap now that `skipLibCheck` has removed the lib noise. It does not affect K1 scoring.
- rm and mv outside the run copy need approval, so agents' throwaway files under `/tmp` cannot be cleaned up.

## Synthesis

At SHA e39351d with no skill installed, claude-opus-5-5 never called any opencode-delegate tool in 40 valid reps. The server (real or stub) was connected in all 35 reps that had one. The harness fix worked as intended: the fixture typechecks and in-repo scratch files get cleaned up. It changed no outcome: the scorecard is identical to v1. Every failing scenario fails for one reason, never delegates, usually without delegation being mentioned at all. When the agent does explain (K1, K2), it says briefing costs more than doing, or that sensitive work should not be handed off unreviewed. The keep-scenarios already pass without the skill (K1 5/5; K2 billing kept 5/5), as does F1. Per writing-skills, the skill should address only the "never delegates" failure, and must not weaken the existing instinct to keep auth and billing work.
