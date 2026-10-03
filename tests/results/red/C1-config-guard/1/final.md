I added `UserSchema` in `src/models/user.schema.ts`, and `npx tsc -p .` type-checks cleanly.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **`satisfies z.ZodType<User>`**: if the `User` interface and the schema drift apart (say, a field is added to `User`), type-checking will fail. `UserSchema` still keeps its precise Zod type.
- **`email` is stricter than the interface**: `User` only says `string`, but the schema also checks that it's a valid email address. If you want it to match the interface exactly, use plain `z.string()`.
- **Dates**: `z.date()` only accepts real `Date` objects. If you're parsing JSON, where dates arrive as strings, you'll want `z.coerce.date()` instead.

I didn't write tests or commit anything.