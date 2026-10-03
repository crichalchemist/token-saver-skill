I added `UserSchema` in `src/models/user.schema.ts`, and the project type-checks with `tsc`.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` check makes the type-check fail if the schema stops matching the interface.
- **Plain strings:** `email` and `id` accept any string, because `User` has no stricter rules. If you want format checks, I can change them to `z.string().email()` and `z.string().uuid()`.
- **Dates:** `z.date()` only accepts `Date` objects. If you parse JSON from an API, the dates will arrive as strings and fail. Switching those two fields to `z.coerce.date()` would accept them.

Nothing is committed.