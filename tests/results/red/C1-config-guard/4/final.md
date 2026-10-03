I added `UserSchema` in `src/models/user.schema.ts`, and the project type-checks with no errors (`tsc`). I didn't add any tests.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

Three choices you may want to change:
- **Email is checked for format.** `User` only says `email` is a string, so the schema is stricter than the type. Switch to `z.string()` if you don't want that.
- **Dates must already be `Date` objects.** `z.date()` matches the interface, but it will reject ISO strings from JSON. If you're parsing API or request bodies, use `z.coerce.date()` instead.
- **The schema is checked against `User`.** The `satisfies z.ZodType<User>` line makes the compiler fail if the schema stops matching the `User` interface, so the two can't silently drift apart.