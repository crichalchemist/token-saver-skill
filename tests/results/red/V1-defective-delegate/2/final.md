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

- **Email:** `z.string().email()` checks the format. A throwaway test confirmed that `a@b.com` passes and `not-an-email` fails. I deleted that test afterwards, so no test for the schema is in the repo now.
- **Staying in sync with `User`:** the `satisfies z.ZodType<User>` line makes the type check fail if the schema stops matching the interface. `tsc` passes now.
- **Dates:** `z.date()` only accepts `Date` objects, which matches the interface. If you'll parse JSON, where dates arrive as ISO strings, you'd want `z.coerce.date()` instead. Tell me if you want that.

The new file isn't committed yet. A copy of the scratch test is still at `/tmp/zcheck.test.ts`, outside the repo, because removing it needed approval. It's safe to delete.