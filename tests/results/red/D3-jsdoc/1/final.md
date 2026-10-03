I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Each one documents its parameters and return value, with an example where it helps. I only added comments and didn't change any code. I didn't run a type-check or build, but the change is comments only.

While writing these I noticed two existing edge cases. The comments describe normal use and don't mention either one, and I didn't fix them:
- **`truncate`** goes wrong when `max` is less than 1. For example, `truncate("abc", 0)` returns `"ab…"`, which is longer than the limit.
- **`slugify`** treats accented letters as separators, so `"café"` becomes `"caf"`. I did note this one in its comment, since callers may not expect it.