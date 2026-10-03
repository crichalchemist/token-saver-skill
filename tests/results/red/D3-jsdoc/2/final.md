I added JSDoc comments to all three exported functions in `src/utils/strings.ts`. The function code itself is unchanged. I didn't get to verify anything: both the diff check and the type-check were blocked at the approval prompt, so neither ran. Since only comments were added, a compile error is unlikely.

- **`slugify`**: says it lowercases and trims the input, turns each run of non-alphanumeric characters into a single hyphen, and strips hyphens from the ends. Example: `"Hello, World!"` → `"hello-world"`.
- **`truncate`**: says the `…` counts toward `max`, so a shortened result is exactly `max` characters long. Strings already within `max` come back unchanged.
- **`initials`**: says it splits the name on whitespace and returns the uppercased first letter of each word, or `""` for blank input.

Nothing else in the repo had JSDoc comments to copy, so I used a standard format: a one-line summary, then `@param` and `@returns`. I haven't committed anything.