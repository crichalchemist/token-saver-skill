I added `UserSchema` in `src/models/user.schema.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

I handed the first draft to the cheaper delegate model (`opencode/big-pickle`), but it got the main requirement wrong: `email` was a plain `z.string()` with no validation. It also added rules that aren't in the `User` type: a UUID-format `id`, a non-empty `name`, and dates converted from strings. I rewrote the file so it matches `User` exactly and validates email.

The type check (`tsc --noEmit`) passes, and so does the existing test suite, which has one unrelated test. I didn't run a quick check that the email rule accepts a good address and rejects a bad one, because that command needed approval. I haven't added tests for the schema.

If your API sends dates as ISO strings in JSON, you'll want `z.coerce.date()` instead of `z.date()`. I kept `z.date()` to match the `Date` fields in `User`.