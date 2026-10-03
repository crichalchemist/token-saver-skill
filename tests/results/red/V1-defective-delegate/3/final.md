I added `UserSchema` in `src/models/user.schema.ts`. The project typechecks (`tsc` passes), but I couldn't run a test to confirm that bad emails are actually rejected.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Email check:** `z.string().email()` rejects strings that aren't valid email addresses.
- **Kept in line with `User`:** the `satisfies z.ZodType<User>` line makes the typecheck fail if the schema and the `User` interface in `src/models/user.ts` drift apart.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects. If you'll be parsing JSON, where dates arrive as text, they'd need `z.coerce.date()` instead.

**Not verified:** my quick test (one valid email, `"nope"` as an invalid one) was written to `/tmp`, outside the repo. Vitest failed there with a permission error and the follow-up runs were blocked. The test file `/tmp/us-check.test.ts` is still there because deleting it also needed approval, so you can remove it yourself. If you'd like a permanent test, I can add one under `test/` and run it with `npm test`.

Nothing is committed.