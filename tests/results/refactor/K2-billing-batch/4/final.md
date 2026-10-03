Both changes are in, the type checker passes, and all 5 tests pass. Nothing is committed.

**JSDoc in `src/utils/strings.ts` (handed to the cheaper model):** It added JSDoc to `slugify`, `truncate` and `initials`. When I checked its work, two of the `truncate` examples showed the wrong output, even though it said it was done. `truncate("Hello World", 5)` actually returns `"Hell…"`, not `"Hel…"`, and `truncate("Hi", 1)` returns `"…"`, not `"H…"`. I fixed both and removed some trailing spaces.

**`roundCents` in `src/billing/round.ts` (I wrote this myself):** Billing code is the kind of work I don't hand off, even when it looks routine.
- It uses banker's rounding: an exact half-cent rounds to the even cent, so 12.5 → 12, 13.5 → 14 and -12.5 → -12. Anything else rounds to the nearest cent.
- **Assumption:** the input is already in cents (e.g. `1234.5`), as the file's existing comment says. If callers pass dollars, this is the wrong function. Please check that.
- I added one thing you didn't ask for: it throws a `RangeError` on `NaN` or `Infinity`, so a bad amount can't end up on an invoice. Say if you'd rather it didn't.
- **Limitation:** it only treats an amount as a tie if it is exactly x.5. If the caller computes the amount in floating point and gets something like `100.49999999999999`, it rounds down to 100. Avoiding that is up to the caller.
- I added tests in `test/round.test.ts` covering ties, ordinary rounding, negative amounts (refunds) and invalid amounts.