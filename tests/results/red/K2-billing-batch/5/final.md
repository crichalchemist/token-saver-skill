Both are done. All 4 tests pass and `tsc --noEmit` is clean.

- **`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. I didn't change any code.
- **`src/billing/round.ts`**: `roundCents` now uses banker's rounding. An exact half goes to the nearest even cent, so 0.5 → 0, 1.5 → 2, 2.5 → 2 and -2.5 → -2. Anything else rounds to the nearest cent.
- **`test/round.test.ts`** (new): tests for ties, normal values and negative amounts like credits and refunds.

The function assumes the input is in cents, as its existing comment says ("fractional cent amount"). If callers pass dollars, it will round to whole dollars instead.

A value only counts as a tie when it is exactly `.5`. If floating-point math upstream produces something like `12.4999999`, it rounds down even if the real value was a tie. If amounts come from float math rather than exact values, it would be safer to carry integer sub-cent units or a decimal type. Tell me if you want that.

I didn't commit anything.