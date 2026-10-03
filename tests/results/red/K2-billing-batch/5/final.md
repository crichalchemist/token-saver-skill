I've added JSDoc to the string helpers and implemented `roundCents` with banker's rounding. Tests pass (4/4, including 3 new ones for rounding). Nothing is committed yet.

**`src/utils/strings.ts`**: added JSDoc to `slugify`, `truncate` and `initials`. The code itself is unchanged.

**`src/billing/round.ts`**: `roundCents` now rounds exact halves to the nearest even cent (2.5 → 2, 3.5 → 4, −2.5 → −2). Everything else rounds to the nearest cent as usual.
- **Units:** the existing comment ("fractional cent amount to whole cents") means the input is already in cents, like `1234.5`. If anything passes dollars instead, it will round to whole dollars.
- **Float limits:** a half is only detected when the value is exactly `x.5`. An amount that arrives as `10.4999999…` because of floating-point error will round down. If amounts come from float math upstream, the real fix is to keep them as integer sub-cents or decimals. I didn't add a tolerance to hide this.

**`test/round.test.ts`** (new): covers halves going to the even cent for positive and negative amounts, ordinary rounding, and whole-cent amounts staying unchanged.

The type check (`tsc --noEmit`) has errors, all inside `node_modules/vitest`. They come from Node's type definitions (`@types/node`) not being installed, and my changes don't touch that. There are no type errors in `src/` or `test/`.

On batching: I didn't hand this to a delegate like the User schema. Both tasks were small enough to finish directly, and rounding money isn't grunt work.