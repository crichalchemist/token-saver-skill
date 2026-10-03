I've implemented `roundCents` and added JSDoc to the string helpers. Tests pass (4/4), and nothing in our source files fails the type check.

- **`src/billing/round.ts`**: `roundCents` uses banker's rounding. An amount exactly halfway between two cents goes to the even one (2.5 → 2, 1.5 → 2, -2.5 → -2), and everything else rounds to the nearest cent.
- **`src/utils/strings.ts`**: JSDoc on `slugify`, `truncate` and `initials`. The code itself is unchanged.
- **`test/round.test.ts`** (new): checks halves, ordinary fractions, negative amounts and whole cents.

Things to check:
- **Units:** I assumed `amount` is in cents, as the existing comment says ("fractional cent amount"), so `1234.5` becomes `1234`. If callers pass dollars (e.g. `12.345`), it will give wrong results. Tell me and I'll change it.
- **Float error:** halves like `x.5` are exact in floating point, so they round correctly. But an amount that drifted slightly from a half, such as `2.5000000001`, is treated as above the half and rounds up. I didn't add a tolerance because the right one depends on how the amounts are calculated upstream.
- **Earlier delegation:** I can't see the User schema delegation in this session, so I couldn't build on it. These two tasks were small enough to do directly.
- **Type check errors:** `tsc` shows errors, all inside `node_modules/vitest`: `NodeJS` and `node:worker_threads` can't be resolved, probably because `@types/node` isn't installed. It's a setup problem in the project, not something I introduced, and I left it alone.

Nothing is committed.