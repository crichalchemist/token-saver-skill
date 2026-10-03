`UserSchema` now exists in `src/models/user.schema.ts`. The email field is checked with `z.string().email()`, and the other fields match the `User` interface: `id` and `name` as strings, `createdAt` and `updatedAt` as dates.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

I tried to hand this to the cheaper model first, but it didn't work out. The task timed out after 5 minutes, and the file it left behind was in the wrong place (`src/models/src/models/`). It also didn't validate emails, and it added rules you didn't ask for: a UUID format for `id`, a non-empty `name`, and converting date strings into dates. So I wrote the file myself and deleted the misplaced folder.

The typecheck passes and the existing test suite passes, but that suite has only one test, in `test/strings.test.ts`, and it doesn't touch this schema. Nothing yet confirms that the schema rejects a bad email or matches the `User` type. Two things to decide:
- **Tests:** I can add tests that reject a bad email and confirm the schema matches `User`.
- **Dates:** If users come from JSON, `createdAt` and `updatedAt` will arrive as strings, and `z.date()` will reject them. Using `z.coerce.date()` would accept them, if you want that.

The new file isn't committed yet.