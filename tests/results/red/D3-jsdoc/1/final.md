I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Each one gets a summary, `@param` tags and a `@returns` tag with an example. The code itself is unchanged.

I didn't run the type-check or `git diff`, because both commands were denied permission. Since only comments were added, the type-check shouldn't change.

The `truncate` doc notes that the `…` counts toward `max`, so a shortened result is exactly `max` characters long. I didn't document what happens when `max` is 0 or negative, because the current output in that case doesn't look intended.