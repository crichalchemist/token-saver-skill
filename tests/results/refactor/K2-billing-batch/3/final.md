Both changes are made. The type check is clean and the test suite passes. Nothing is committed.

**JSDoc for `src/utils/strings.ts`: handed to the cheaper delegate model.** I read the diff. It only adds comments to `slugify`, `truncate` and `initials`, and the function bodies didn't change. The delegate flagged an existing edge case: `truncate("hello", 0)` returns `"hell…"`. That breaks the "result is `max` characters" contract the new doc describes. I left the code alone because you only asked for docs.

**`roundCents` in `src/billing/round.ts`: written by me.** This is billing logic, so I didn't delegate it even though it's short. It rounds exact halves to the nearest even cent (so 2.5 → 2 and 3.5 → 4) and everything else to the nearest cent.

Two things for you to confirm:
- **Input units:** I assumed `amount` is already in cents (e.g. `1234.5` → `1234`), as the existing comment "fractional cent amount" suggests. If callers pass dollars, it needs to multiply by 100 first.
- **Small float errors count as halves:** a value within about 1e-9 of a half is treated as a half. So `2.675 * 100`, which JavaScript computes as `267.49999999999997`, rounds as a tie to `268` instead of down to `267`. Without that tolerance, totals computed with floats would round the wrong way. Tell me if you'd rather have strict float behaviour.

I checked 14 cases with a throwaway test and then deleted it: positive and negative halves, non-halves, the float-error cases and whole numbers. No permanent test was added for `roundCents`. I can add one if you want it in the suite.