Both are done. All 4 tests pass and the type check (`tsc --noEmit`) is clean.

I did these myself instead of delegating them. They're small enough that handing them off would take longer, and I didn't want rounding money sent to a cheaper model without checking it.

**`roundCents`** (`src/billing/round.ts`)
- **Assumption:** the input is a fractional number of **cents**, not dollars, as the existing comment in the file says. So `123.5` becomes `124`. If callers actually pass dollars, this is the wrong unit, so please confirm.
- Exact halves round to the nearest even cent: `0.5 → 0`, `1.5 → 2`, `2.5 → 2`, `-2.5 → -2`. Everything else rounds normally with `Math.round`.
- A value that is a half plus a tiny decimal rounding error (within `1e-9`) still counts as a tie. For example, `0.1 + 0.2 + 2.2` comes out as `2.5000000000000004`, and it still rounds to `2`.
- I added `test/round.test.ts` to cover ties, normal rounding, negative amounts and the rounding-error case. The tests failed before I wrote the code and pass now.
- One limit: plain JS numbers can't represent fractional cents exactly. If invoice amounts ever get large or need exact precision, switching to integer or decimal arithmetic would be safer. That's beyond what you asked for, so I didn't do it.

**JSDoc** (`src/utils/strings.ts`): I documented `slugify`, `truncate` and `initials` without changing any code. The `slugify` doc notes that it deletes accented and other non-ASCII letters rather than converting them to plain letters, which might surprise someone.

Nothing is committed yet. Tell me if you want me to commit.