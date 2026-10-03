Both changes are in. The type checker and the existing test suite pass (1 test). I couldn't run any rounding cases: both attempts (via `tsx` and via `node`) were held for permission approval. There are also no tests for `roundCents` yet, so its behavior is unverified beyond type-checking.

**JSDoc in `src/utils/strings.ts` (delegated):** a cheaper model (`opencode/big-pickle`) wrote this. I read the diff: each of `slugify`, `truncate` and `initials` now has a summary, parameter and return notes, and an example. The descriptions match what the code does, and no code lines changed.

**`roundCents` in `src/billing/round.ts` (written by me):** I kept this one because it's billing code. A rounding mistake ends up on invoices, so I didn't treat it as grunt work. It does round-half-to-even:
- 2.5 → 2, 3.5 → 4
- -2.5 → -2 (ties go to the nearest even number for negative amounts too)
- anything else rounds to the nearest cent

Two assumptions you should check:
1. **The input is already in cents** (e.g. `1234.5` → `1234`), as the existing comment says. If callers pass dollars, it's wrong.
2. **Ties are exact `.5` values.** If the amount comes out of float math that lands just off `.5` (like `2.4999999`), it rounds normally rather than as a tie. Adding a tolerance or using integer math would handle that, but I didn't add either without knowing how amounts are produced.

Neither change is committed. If you approve a quick Node run, or want `test/round.test.ts` added, I'll check the cases above.