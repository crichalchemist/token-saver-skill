I added `UserSchema` in `src/models/user.schema.ts`. It has one Zod field for each property of `User` in `src/models/user.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

**The delegated attempt failed.** I first gave this to the cheaper delegate model. It reported "Done", but no file was created and `git status` was still clean. So I wrote the file myself.

**Checks:** the project type check (`tsc --noEmit -p .`) shows no errors, and the one existing test passes. No test covers the schema, and I didn't run a check that the type Zod infers from the schema exactly matches `User`; I compared the fields by eye.

**Choices you may want changed:**
- `email` must be a valid email address. `User` only says `string`, so this is stricter than the interface.
- `createdAt` and `updatedAt` only accept real `Date` objects. Dates coming from JSON arrive as strings and will fail. If you'll parse JSON input, I can switch these to `z.coerce.date()`, which converts strings to dates.

Nothing has been committed.