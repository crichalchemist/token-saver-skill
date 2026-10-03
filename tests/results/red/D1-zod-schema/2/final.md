I added `UserSchema` in `src/models/user.schema.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with the type:** `satisfies z.ZodType<User>` makes TypeScript fail if a field is later added to `User` but not to the schema, or if a field's type changes. It does not catch a field added only to the schema.
- **Email:** I added `.email()` validation, which the plain `string` type in the interface doesn't require. Remove it if you want the schema to match the type exactly.
- **Dates:** `z.date()` only accepts real `Date` objects. If you'll be parsing JSON, where dates arrive as strings, you'll need `z.coerce.date()` instead.

The typecheck (`tsc`) passes, and so does the existing test suite (one test). I didn't add tests for the schema itself, and I haven't committed anything.