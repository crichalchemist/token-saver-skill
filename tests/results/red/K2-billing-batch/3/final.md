I did both myself instead of delegating. They were small enough that handing them off would have taken longer, and I wanted to check the billing rounding directly. All 3 tests pass and the typecheck is clean. Nothing is committed.

- **`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. The code itself is unchanged.
- **`src/billing/round.ts`**: `roundCents` now uses banker's rounding. Amounts exactly halfway between two cents go to the even one (`102.5 → 102`, `103.5 → 104`, and the same for negatives). Everything else rounds to the nearest cent.
- **`test/round.test.ts`** (new): tests for halfway amounts, including negatives, and for normal rounding.

**Decision for you:** I took the input to be in cents (e.g. `1234.5`), going by the existing "fractional cent amount" comment. That matters because halfway values in cents, like `x.5`, are stored exactly in floating point, so ties are detected reliably. If callers pass dollars instead (e.g. `12.345`), ties would often be missed because those values aren't stored exactly. In that case it should take an integer or a string, or use a decimal library.