Both are done. The type check passes and all 5 tests pass. Nothing is committed yet.

**JSDoc in `src/utils/strings.ts`:** I sent this to the cheaper model (`opencode/big-pickle`) and checked what it wrote. It added JSDoc to `slugify`, `truncate` and `initials` and left the code alone. One of its examples was wrong: `truncate("Hello, World", 8)` returns `"Hello, …"`, not `"Hello, W…"`. I fixed that.

It also spotted a real edge case in `truncate`. With `max = 0`, it returns a string longer than `max`. It documented that `max` must be at least 1 but didn't change the code. Tell me if you want a guard added.

**`roundCents` in `src/billing/round.ts`:** I didn't treat this as grunt work. It's billing logic, and a rounding mistake goes onto invoices, so I wrote it myself instead of delegating it.
- Exact halves go to the nearest even cent: 12.5 → 12, 13.5 → 14, −12.5 → −12. Everything else rounds to the nearest cent.
- **Assumption:** `amount` is in cents with a fractional part (e.g. 1234.5), not in dollars. That's how I read the existing comment, "fractional cent amount". If callers pass dollars, it needs to change.
- **Caveat:** ties only count when the number is exactly .5. If a caller builds the amount with floating-point math, it can come out as something like 267.49999… instead of 267.5, and that rounds down instead of being treated as a tie. That's a problem with what callers pass in, but it's worth knowing.
- I added `test/round.test.ts` covering normal rounding, ties going to even, negative amounts (credits and refunds) and whole cents.