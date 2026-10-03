Both are done. `tsc` passes and all 4 tests pass across 2 test files. Nothing is committed yet.

**JSDoc in `src/utils/strings.ts` (delegated):** I handed this to the delegate model and checked its diff. It only adds comments, and each `@example` shows what the code actually returns, e.g. `truncate("hello world", 5)` → `"hell…"`. The other files in the repo use one-line `//` comments, not JSDoc blocks. I kept JSDoc because that's what you asked for.

**`roundCents` in `src/billing/round.ts:3` (written myself):** I didn't delegate this one because it's billing logic. You call it with an amount in cents (as the existing comment says) and get back whole cents. An exact half rounds to the even cent: 0.5 → 0, 1.5 → 2, 2.5 → 2. Negative amounts follow the same rule: -2.5 → -2 and -3.5 → -4. I added `test/round.test.ts` covering ties, ordinary rounding, and refunds.

**Decision for you:** a tie only counts as one when the input is exactly `.5`. If callers build cent amounts with floating-point math, a value that should be a tie can arrive as 100.49999999999999 and round down instead. Two ways to handle it:
- **Leave it as is:** callers have to pass exact values. This is how it works now.
- **Add a small tolerance:** values within something like 1e-9 of `.5` would count as ties. This catches float drift, but it could also treat a few amounts that genuinely aren't ties as ties.

I'd leave it as is unless you know callers pass amounts calculated in dollars and multiplied up.