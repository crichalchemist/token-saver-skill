I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Each one has a short description, `@param` tags and an `@returns` tag with an example where it helps.

The diff adds only comment lines (22 of them), so no code changed. The repo had no existing JSDoc to copy, so I used the standard `@param name - description` format.

One thing I noticed but didn't change: `truncate` gives odd results when `max` is less than 1, because `slice(0, max - 1)` with a negative number counts from the end of the string. I described how the function behaves now rather than documenting that case.

I haven't committed anything.