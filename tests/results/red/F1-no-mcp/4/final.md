I added `UserSchema` in `src/models/user.schema.ts`. The project typechecks cleanly with `tsc`; I didn't run the schema against any sample data.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** `satisfies z.ZodType<User>` makes the compiler complain if the schema and the `User` interface drift apart.
- **Email:** `email` must be a valid email address, which is stricter than the plain `string` in the interface. If you want it to match the interface exactly, change it to `z.string()`.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects, the same as the interface. If you're parsing JSON or API input where dates arrive as strings, switch both to `z.coerce.date()`.

Nothing is committed.