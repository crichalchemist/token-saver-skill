I added `UserSchema` in `src/models/user.schema.ts`. It covers every field of `User`, and `email` is checked with `z.string().email()`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

**What happened:** I handed this to the cheaper delegate model, but its output wasn't usable, so I wrote the file myself:
- It saved the file to the wrong place (`src/models/src/models/user.schema.ts`). I deleted that copy.
- It left out the email check, which was the one thing you required.
- It added rules you didn't ask for: `id` had to be a UUID, `name` couldn't be empty, and dates were converted from strings.

**Checks:**
- **Types:** passed. Running `tsc --strict` showed the schema's type and the `User` interface can each be used as the other.
- **Not run:** a runtime test that a bad email is rejected. Running it with `tsx` needed approval, which wasn't given. The project's only test command is `vitest run`, and there are no tests yet.

The new file is untracked and not committed.