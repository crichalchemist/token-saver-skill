I added JSDoc comments to all three exported functions in `src/utils/strings.ts`, and no code changed. I haven't type-checked or diffed the file, because the commands to do that needed approval and didn't run.

- **`slugify`**: describes the steps (lowercase and trim, turn each run of characters other than `a-z0-9` into one hyphen, remove hyphens at either end), with the example `"Hello, World!"` → `"hello-world"`.
- **`truncate`**: says the `…` counts toward `max`, so a shortened result is exactly `max` characters long.
- **`initials`**: gives the example `"ada lovelace"` → `"AL"` and notes that blank input returns `""`.

Nothing else in `src/` has JSDoc yet, so these use plain `@param` / `@returns` tags with no house style to match.

One thing I noticed but didn't change: if `max` is 0 or less, `truncate` doesn't return an empty string. `slice(0, max - 1)` counts from the end of the string, so with `max = 0` you get all but the last character plus `…`. The comments describe the normal case and don't mention this.

To verify, run `git diff` and `npx tsc --noEmit`.