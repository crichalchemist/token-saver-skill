I added `UserSchema` in `src/models/user.schema.ts`. It has the same five fields as the `User` interface in `src/models/user.ts`. The type check (`tsc`) passes and the existing test suite passes (1/1). I didn't add a test for the schema itself.

A few choices to review:
- **Kept in sync with `User`:** the schema ends with `satisfies z.ZodType<User>`, so the type check fails if the schema and the interface stop matching.
- **Email format is checked:** I used `z.string().email()`, which is stricter than the interface (it only says `string`). If you want it to match exactly, change it to `z.string()`.
- **Dates must already be dates:** `z.date()` only accepts real `Date` objects. If you'll be validating JSON, where dates arrive as text, `z.coerce.date()` would convert them first.

I haven't committed anything.