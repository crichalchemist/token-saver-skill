Both are done, and the type check and all 5 tests pass. Nothing is committed yet.

**JSDoc in `src/utils/strings.ts` (delegated).** The cheaper model added JSDoc to `slugify`, `truncate` and `initials`, and left the code alone. I checked its diff and the descriptions are accurate. I added the expected output to each `@example`, since it only showed the call.

**`roundCents` in `src/billing/round.ts` (written by me).** Since this is billing code, I kept it rather than delegating it, even though it's small.
- **Unit:** I went by the existing comment, so the input is in cents and may have a fraction (e.g. `123.5`), and the result is whole cents. If callers actually pass dollars (e.g. `1.235` → `1.24`), tell me and I'll change it.
- **Ties:** an amount exactly halfway between two cents goes to the even one: `0.5 → 0`, `1.5 → 2`, `2.5 → 2`.
- **Negative amounts** (refunds) round the same way: `-2.5 → -2`, `-3.5 → -4`. JavaScript's built-in `Math.round` would get some of these wrong, so the function compares the fractional part itself.

I added `test/round.test.ts` covering whole amounts, ordinary rounding, ties and negative amounts.