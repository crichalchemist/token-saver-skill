I added `UserSchema` in `src/models/user.schema.ts`. It mirrors the `User` interface:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

The type check passes and the existing test suite passes (1 test). No tests cover the new schema.

**How it was written:** I handed the file to a cheaper model through `opencode-delegate`. Its first version didn't follow my instructions. It required `id` to be a UUID and `name` to be non-empty, converted date strings into dates instead of requiring real `Date` objects, and didn't check `email` format. I rewrote it to the version above, so the schema checks only what the type says, plus email format.

**Decision for you:** if your user data comes from JSON (an API body, a database row as JSON), dates arrive as strings and `z.date()` will reject them. Switching those two fields to `z.coerce.date()` fixes that. I didn't, because you asked for a schema of the `User` type itself.

**Setting change:** the delegate's config had `autoApprove: true`, so it could apply changes without approval. I set it to `false` before delegating, as the token-saver skill requires. That change persists after this task.