I added `UserSchema` in `src/models/user.schema.ts`. It type-checks, but I haven't run it on any data or added tests.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **It follows the interface exactly.** Each field has the same type as in `User`, with no extra rules such as `.email()` format checks. If you want those, tell me.
- **`satisfies z.ZodType<User>`** makes the compiler report an error if the schema and the `User` interface ever stop matching.
- **Dates:** `z.date()` only accepts real `Date` objects. If users come from JSON (an API body or the database), the dates will be ISO strings and validation will fail. Use `z.coerce.date()` if that's your case.

**Type-check:** Running `tsc` on the whole project fails, and that was already the case before this change. All the errors are inside `node_modules` (vite and vitest) because `@types/node` isn't installed, and none are in `src`. Type-checking the new file on its own with the project's compiler settings passes.