I added `UserSchema` in `src/models/user.schema.ts`. It's a `z.object` with one field for each property of the `User` interface:

- `id` and `name` are strings.
- `email` is a string with an email-format check (`z.string().email()`), which the interface itself doesn't require.
- `createdAt` and `updatedAt` use `z.date()`, so they accept `Date` objects only. ISO date strings, like those in parsed JSON, will be rejected. If you need to accept those, `z.coerce.date()` would convert them.

The project type-checks cleanly with `tsc`. I didn't run the tests, and I didn't separately confirm that the schema's inferred type matches `User` in both directions, because that check needed a command you hadn't approved. The field list mirrors the interface one-for-one, though.

Nothing is committed yet.