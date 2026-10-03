I added JSDoc comments to all three exported functions in `src/utils/strings.ts`. The only change is 25 added comment lines; the code itself is untouched.

- **`slugify`**: describes the lowercase/trim/hyphenate steps, with an example (`"Hello, World!"` → `"hello-world"`).
- **`truncate`**: notes that the `…` counts toward `max`, so a cut string is exactly `max` characters long.
- **`initials`**: takes a whitespace-separated name and returns uppercase initials (`"ada lovelace"` → `"AL"`).

The type-check passes when library type files are skipped (`--skipLibCheck`), and the one existing test passes. A plain `tsc --noEmit` fails with about 55 errors, all from vitest/vite type files that can't find `@types/node`. This was already the case before my change: no `src/` file appears in the errors. Installing `@types/node` as a dev dependency would probably fix it; I didn't, because it's outside this task.

Nothing is committed.