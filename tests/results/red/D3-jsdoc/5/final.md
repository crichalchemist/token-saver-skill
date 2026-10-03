I've added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. I didn't change any code. I haven't checked the result: the diff check and the TypeScript compile both needed your approval and weren't run. The comments can't change behaviour, but if you want to confirm, run `git diff` and `npx tsc --noEmit`.

There was no existing JSDoc in `src/` to match, so I used the standard `@param` / `@returns` format. Each comment includes an example where it helps, plus a few behaviours that aren't obvious from the function name:

- **`slugify`:** accented and other non-ASCII letters are treated as separators, so they disappear from the slug instead of being converted to plain letters.
- **`truncate`:** the `…` counts toward `max`, so a shortened string is exactly `max` characters long.
- **`initials`:** blank input returns an empty string.

I didn't commit anything.