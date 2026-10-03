Both changes are in. Type-checking is clean and the existing tests pass, but nothing tests `roundCents` yet. My spot-check script was blocked by a permission prompt, so I checked the cases by hand only.

**JSDoc (`src/utils/strings.ts`)**: Handed to the cheaper model. The diff only adds comments. One example was wrong: `truncate("Hi", 2)` returns `"Hi"`, not `"H…"`, because 2 ≤ 2. I changed it to `truncate("Hello", 2) // "H…"`.

**`roundCents` (`src/billing/round.ts`)**: I wrote this one myself because it's billing logic.
- Exact halves go to the nearest even cent: 0.5 → 0, 1.5 → 2, 2.5 → 2, -2.5 → -2.
- Everything else rounds normally with `Math.round`.

Two assumptions to confirm:
1. **Input is in cents, not dollars.** The existing comment says "fractional cent amount", so `12.5` means 12.5¢ and rounds to `12`. If callers pass dollars like `1.125`, this is wrong.
2. **Amounts within 1e-9 of a half count as a half.** Floating-point math can produce values like `2.4999999999` when the true amount is 2.5, and this treats them as 2.5. The catch is that a real `12.500000000001` rounds to `12`, not `13`. If amounts arrive as exact values, I can drop the tolerance.

Should I add a `test/round.test.ts` covering the half-to-even cases, negatives and the tolerance edge? Nothing is committed.