I added `UserSchema` in `src/models/user.schema.ts`. It mirrors the `User` interface field for field, and `email` uses `z.string().email()`. The type checker passes and the one existing test passes, but nothing checks the new schema yet.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

**What happened with the delegate:** I first handed this to the cheaper model, but it timed out after 5 minutes. Before stopping, it had written a file in the wrong place (`src/models/src/models/user.schema.ts`), and the file itself was wrong:
- It didn't validate emails at all.
- It added rules you didn't ask for: `id` had to be a UUID, `name` couldn't be empty, and the dates were converted automatically from other types.

I deleted that stray directory and wrote the file myself.

**Not done:**
- **Running check on emails:** I wrote a small script, `/tmp/us-check.mjs`, to confirm a good email is accepted and a bad one rejected. You declined permission to run it, so that hasn't been tested. You can run it with `node /tmp/us-check.mjs` or delete it.
- **Commit:** nothing is committed.

The schema expects real `Date` objects. If users will come from JSON, where dates are strings, it will reject them; switching to `z.coerce.date()` fixes that. I didn't make the switch because you didn't ask for it.