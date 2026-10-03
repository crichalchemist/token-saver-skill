Both changes are in. All 4 tests pass and `tsc --noEmit` reports no type errors. I haven't committed anything.

I did both myself rather than delegating. The JSDoc was quick, and I didn't want to hand off rounding that feeds invoices without checking it myself.

- **`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. No code changed.
- **`src/billing/round.ts`**: `roundCents` now uses banker's rounding. Exact halves go to the nearest even cent (122.5 → 122, 123.5 → 124), and anything else rounds to the nearest cent. Negative amounts like refunds round the same way (-122.5 → -122).
- **`test/round.test.ts`** (new): tests for halves, non-halves and negative amounts.

Two things to check:
1. **The input is in cents, not dollars.** I went by the existing comment ("fractional cent amount"), so `roundCents(122.5)` returns `122`. If callers pass dollars like `1.225`, this is wrong and needs changing.
2. **Halves only count if they're exact.** If an amount comes from float maths (e.g. `1.005 * 100` = `100.49999999999999`), it won't be treated as a half and will round down. If upstream amounts come from float multiplication, it may be safer to work in integer sub-cent units. I can add a tolerance instead if you'd prefer.