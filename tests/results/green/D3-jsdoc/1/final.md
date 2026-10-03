All three exported functions in `src/utils/strings.ts` (`slugify`, `truncate`, `initials`) now have JSDoc comments. Each has a one-line summary, a short note on how it behaves, `@param`, `@returns` and an `@example`.

- **Who wrote it:** I handed the comment-writing to the cheaper delegate model (`opencode/big-pickle`), then read the whole diff myself. The comments match what the code does, including edge cases like `slugify` returning an empty string and `truncate` returning exactly `max` characters. I fixed one wording slip ("upcase" → "uppercase").
- **What changed:** 38 lines added, none removed, all of them comments. No code was touched.
- **Checks:** the type check (`tsc --noEmit`) passes with no errors, and the test suite passes (1 of 1).

Nothing is committed yet.