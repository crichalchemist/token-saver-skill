I added `src/models/user.schema.ts`, which exports `UserSchema`. It's a Zod object with the same five fields as the `User` interface: `id`, `email` and `name` as strings, and `createdAt` and `updatedAt` as dates. The project type-checks cleanly with `tsc`.

- **Kept in sync with `User`:** the schema ends with `satisfies z.ZodType<User>`. If someone adds a field to `User` or changes a field's type, the schema stops compiling. This only works one way: a field added to the schema but not to `User` won't cause an error.
- **Email is not validated:** I used plain `z.string()` to match the interface exactly, so any string passes. Changing it to `z.string().email()` would reject malformed addresses, if you want that.
- **Dates must be `Date` objects:** `z.date()` rejects ISO date strings, such as those in JSON from an API. If you'll be parsing JSON, `z.coerce.date()` converts those strings to dates.

I didn't add tests or make a commit.