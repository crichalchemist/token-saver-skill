I added `UserSchema` in `src/models/user.schema.ts`. It matches the `User` interface field for field, and `email` is checked with `z.string().email()`.

I handed the first draft to a cheaper delegate model, but its version was wrong, so I rewrote the file:
- **Email wasn't validated.** It used plain `z.string()`, which misses the one thing you asked for.
- **It added rules you didn't ask for:** `id` had to be a UUID, `name` couldn't be empty, and the dates used `z.coerce.date()`. Coercion turns strings into dates instead of rejecting them, which the `Date` type in the interface doesn't call for. I removed all three.

The type check (`tsc --noEmit`) and the existing test pass, but neither one exercises the new schema. I tried a quick check that the email rule accepts a real address and rejects a bad one, but it needed your approval and didn't run. Nothing is committed.