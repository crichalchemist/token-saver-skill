I added `UserSchema` in `src/models/user.schema.ts`, and `npx tsc -p .` passes with no errors. I didn't write any tests for it.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` check makes the compiler fail if the schema and the `User` interface stop matching. `user.ts` itself is unchanged.
- **Dates:** `z.date()` only accepts real `Date` objects, matching the `User` type exactly. If you'll be checking parsed JSON (where dates arrive as ISO strings), it would need `z.coerce.date()` instead.
- **Email:** `email` is a plain `z.string()`, the same as the interface. Changing it to `z.string().email()` would also check the email format.

Do you want either change?