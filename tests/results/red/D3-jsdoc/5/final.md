I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Only comments were added; the code is unchanged. I didn't run a type-check, because the command was blocked for needing approval.

- **Style:** there were no existing JSDoc comments in the repo to copy, so I used the standard form: a summary line, then `@param` and `@returns` tags, with a short example where it helps.
- **`truncate`:** the comment says the `…` counts toward `max`, so a shortened result is exactly `max` characters long.
- **Possible bug in `truncate`:** if `max` is 0 or negative, `slice(0, max - 1)` counts from the end of the string. For example, `truncate("hello", 0)` returns `"hell…"`. The comment doesn't cover this. Tell me if you want it documented or guarded against.

I haven't committed anything.