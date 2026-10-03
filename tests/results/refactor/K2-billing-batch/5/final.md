Both tasks are done. All 4 tests pass and `tsc --noEmit` reports no errors. Nothing is committed yet.

**JSDoc in `src/utils/strings.ts` (delegated):** I sent this to the cheaper model. I checked its diff: it added JSDoc to `slugify`, `truncate` and `initials` and left the function bodies unchanged. I checked each `@example` against the code and they're all correct.

**`roundCents` in `src/billing/round.ts` (done myself):** I didn't delegate this one even though you called it grunt work, because a rounding mistake in billing gets expensive. It uses banker's rounding: a value exactly halfway between two cents goes to the even one, so `122.5 → 122` and `123.5 → 124`. Negative amounts round the same way in reverse, so `-122.5 → -122`. I added `test/round.test.ts` to cover half-way values, ordinary rounding and refunds.

Two things to check before this goes live:
- **Input unit:** I took the existing comment ("fractional cent amount") to mean the input is in cents, like `123.5`. If callers pass dollars, like `1.235`, it will give the wrong answer, and the function needs to change.
- **Floating-point error:** it only treats exactly `.5` as a tie. If the amount was built up through float arithmetic, a value meant to be `2.5` might be stored as `2.4999999…` and round down. If amounts come from sums or multiplications rather than whole-number cents, tell me and I'll add a small tolerance or switch to integer math.