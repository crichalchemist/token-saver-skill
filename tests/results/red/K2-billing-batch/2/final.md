Both are done. All 4 tests pass and the typecheck is clean. Nothing is committed yet.

**1. JSDoc in `src/utils/strings.ts`:** I added doc comments to `slugify`, `truncate` and `initials`. No code changed.

**2. `roundCents` in `src/billing/round.ts`:** It now uses banker's rounding: an exact half-cent goes to the even cent (`2.5 → 2`, `3.5 → 4`, `-2.5 → -2`). Anything else rounds to the nearest cent. I didn't treat this as grunt work because it's billing logic, so I wrote the test first in `test/round.test.ts`. It covers ties, normal rounding, and credits (negative amounts) rounding the same way as charges.

**Decisions for you:**
- **Input units:** going by the existing comment, I assumed `amount` is already in cents (e.g. `1234.5` cents gives `1234`). If callers pass dollars (`12.345`), this is wrong and needs a ×100 step. Since there are no callers yet, I couldn't check.
- **Float precision:** only true halves count as ties. A value that comes out of float math as `100.49999…` (like `1.005 * 100`) rounds down. I didn't add a tolerance because it would quietly change results on real non-tie amounts. If amounts come from float multiplication upstream, it may be worth switching to integer or decimal math there.

Also, I don't have any record of delegating the User schema earlier today. This session has no sign of it, and I didn't touch `src/models/user.ts`. If that work was meant to be part of this batch, it may not have happened.