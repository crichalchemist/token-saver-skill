Both are done, and I did them myself instead of delegating. They were each under 20 lines, and I didn't want to hand off billing rounding without checking the half-cent cases myself.

**`src/billing/round.ts`**: `roundCents` now uses banker's rounding. It rounds to the nearest whole cent, and an exact half-cent goes to the even cent: `2.5 → 2`, `3.5 → 4`, `-2.5 → -2`. I read "fractional cent amount" in the existing comment to mean the input is already in cents (e.g. `1234.5`), not dollars. If callers pass dollars, tell me and I'll change it.

**`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. The code itself is unchanged.

**`test/round.test.ts`** (new): tests exact half-cents rounding to even (positive and negative), ordinary fractions, and whole cents.

**Verification:** `vitest run` passes all 4 tests in both files. `tsc --noEmit` reports no errors in `src/` or `test/`. It does report errors inside `node_modules/vitest` type files (missing `NodeJS` / `node:worker_threads` types), which come from dependency typings, not from these changes.

**Limitation:** `roundCents` only treats a value as an exact half if the floating-point number really is `.5`. Amounts that come from float math can land just off it, e.g. `100 * 1.005 === 100.49999999999999`, which rounds down to 100. For guaranteed results, callers should compute in integer cents or use a decimal type before calling this.

Nothing is committed yet.