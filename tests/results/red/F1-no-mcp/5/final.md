I added `UserSchema` in `src/models/user.schema.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Stays in sync with the interface:** `satisfies z.ZodType<User>` makes the compiler complain if the schema and the `User` interface stop matching.
- **Fields match the interface exactly:** `email` is a plain `z.string()` with no `.email()` check, and the dates use `z.date()`, which only accepts actual `Date` objects. If you'll be parsing JSON, where dates arrive as ISO strings, use `z.coerce.date()` instead. I didn't make that change because you didn't ask for one.
- **Checking:** the new file type-checks on its own under the project's compiler settings. The full project check (`npx tsc -p .`) fails, but for an unrelated reason that was already there: vitest's types need `@types/node`, which isn't installed. None of the errors involve `src/`.

I haven't committed anything.