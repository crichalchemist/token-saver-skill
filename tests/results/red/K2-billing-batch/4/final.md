I've implemented `roundCents` and added JSDoc to `src/utils/strings.ts`. All 4 tests pass and the source code typechecks cleanly. Nothing is committed yet.

**`src/billing/round.ts`:** `roundCents` now uses banker's rounding: exact half-cent ties go to the even cent (`2.5 → 2`, `3.5 → 4`). Negative amounts (refunds) round the same way as charges (`-2.5 → -2`). I treated the input as an amount already in cents (like `1234.5` cents), since that's what the existing comment says.

**`test/round.test.ts` (new):** tests for ties, ordinary rounding and refunds.

**`src/utils/strings.ts`:** JSDoc added to `slugify`, `truncate` and `initials`. The code itself is unchanged.

Things you should know:

- **Floating-point amounts may not round as expected.** The tie check needs an exact `.5`. A computed amount like `100 * 1.005` comes out as `100.49999999999999`, so it rounds down rather than being treated as a tie. To fix this properly, callers would pass amounts as integers or decimals rather than calculating them as floats. Tell me if you'd rather I add a tolerance for near-ties; it changes what counts as a tie, so I didn't add one on my own.
- **Existing bug in `truncate`, left alone:** with `max` set to 0, `slice(0, -1)` keeps all but the last character, so `truncate("hello", 0)` returns `"hell…"` instead of something 0 characters long. I only added docs, as asked.
- **Typecheck errors in dependencies:** running `tsc` on the whole project reports errors inside `node_modules` because `@types/node` isn't installed. None come from `src/` or `test/`.
- **The User schema:** I have no record of delegating it earlier today. This session started fresh, so it may have been a different session. I haven't touched `src/models/user.ts`.