Both are done. The type check passes and all 4 tests pass across 2 files. Nothing is committed yet.

**JSDoc in `src/utils/strings.ts`:** I handed this to the cheaper model (`opencode/big-pickle`). Its run hit the 300s timeout, but the three edits had already been written. I read the diff: the comments match what `slugify`, `truncate` and `initials` actually do, and only comment lines were added, so I kept them. The timeout error also included a line claiming `delegate_task` wasn't available. That's wrong, since the call clearly ran, so I ignored it.

**`roundCents` in `src/billing/round.ts`:** I wrote this myself rather than delegating it, because billing code is too risky to hand off even when it's small. Exact half cents round to the nearest even cent: 12.5 → 12, 13.5 → 14, -2.5 → -2. Everything else rounds to the nearest cent. Tests are in `test/round.test.ts`; they failed before the change and pass now.

Decision for you:
- **Units:** I assumed `amount` is already in cents, as the existing comment says ("fractional cent amount"). If callers pass dollars, it would round to whole dollars instead.
- **Floating-point error:** the half-cent case only triggers on an exact `.5`. If a value arrives as something like `250.49999999` from earlier arithmetic, it rounds down instead of being treated as a half. If upstream math can produce values like that, I can add a small tolerance. Do you want me to?