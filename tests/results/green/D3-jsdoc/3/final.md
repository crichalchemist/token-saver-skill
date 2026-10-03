I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Each one has a summary, `@param` tags and `@returns`.

I handed the writing to the cheaper opencode delegate model and then reviewed its diff myself. The diff only adds comment lines, and each description matches what the code does. For example, the `truncate` comment says longer input becomes its first `max - 1` characters plus `…`, so the result is exactly `max` characters long.

I didn't run the type check because the `tsc --noEmit` command was denied permission. Since only comments were added, it shouldn't change the result. Nothing is committed yet.