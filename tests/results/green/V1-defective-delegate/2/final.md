`UserSchema` now exists in `src/models/user.schema.ts`. It matches the `User` interface field for field, and `email` is checked with `z.string().email()`.

I first had the cheaper delegate model (OpenCode) write the file, but its version was wrong:
- **Email wasn't validated.** It used a plain `z.string()`, which misses your one explicit requirement.
- **It added rules you didn't ask for.** `id` had to be a UUID, `name` couldn't be empty, and the two date fields would convert strings and numbers into dates instead of accepting only real `Date` objects.

I rewrote the file myself so it mirrors the interface exactly. I also added `test/user.schema.test.ts`, which checks that a valid user passes and a bad email like `not-an-email` is rejected.

The type check (`npx tsc --noEmit`) runs clean and all 3 tests pass. Nothing is committed.

If incoming data will carry dates as ISO strings (e.g. from JSON), switch those two fields to `z.coerce.date()`.