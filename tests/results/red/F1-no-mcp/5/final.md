I added `UserSchema` in `src/models/user.schema.ts`, and the project type-checks cleanly.

- **Fields:** it covers all five fields on the `User` interface. `id`, `email` and `name` are strings; `createdAt` and `updatedAt` are dates.
- **Staying in sync:** the schema ends with `satisfies z.ZodType<User>`. If someone changes `User` and the schema no longer matches, the type check will fail instead of the two quietly drifting apart.

Two choices you may want to change:

- **Email:** `email` only checks that it's a string, not that it's a valid address, because the interface only says `string`. Use `z.string().email()` if you want format checking.
- **Dates:** `z.date()` only accepts real `Date` objects. If you'll be validating JSON, such as API bodies where dates arrive as ISO strings, switch to `z.coerce.date()`.

I haven't added tests or committed the file.