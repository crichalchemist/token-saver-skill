I've added the JSDoc and implemented `roundCents`, and all 5 tests pass. I haven't committed anything.

**`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. The code itself is unchanged.

**`src/billing/round.ts`**: `roundCents` now uses banker's rounding, so a value exactly halfway between two cents goes to the even one:
- `100.5 → 100`, `101.5 → 102`, `-2.5 → -2`. Values that aren't ties round normally.
- Values within `1e-9` of a half cent count as ties. Without that, computed amounts like `0.1 * 25` (which comes out as `2.5000000000000004`) would round up when they should round to even.
- It assumes the input is already in **cents** (e.g. `1234.5`), going by the existing comment ("fractional cent amount"), and returns whole cents. If callers pass dollars, it will give wrong results, so check that before it's used.

I added `test/round.test.ts` with 4 tests covering ties, normal rounding, negative amounts (credits) and the floating-point tie case.

**Type-check:** `tsc --noEmit` reports errors, but all of them are inside `node_modules/vitest` type files and say the Node types are missing. The project probably needs `@types/node` installed. None of the errors are in `src/` or `test/`, and I didn't fix this since it's outside what you asked for.

I did both tasks directly rather than delegating them. The JSDoc took less effort than writing a brief, and rounding money is easy to get subtly wrong, so I didn't treat it as grunt work.