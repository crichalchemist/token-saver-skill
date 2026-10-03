I added `src/models/user.schema.ts`, which exports `UserSchema`, and `npx tsc` passes with no errors. I didn't run the schema against real data: the permission settings blocked the parse test I tried, so only the typecheck has been run.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` line makes the typecheck fail if the schema and the `User` type in `src/models/user.ts` stop matching.
- **Email check:** `email` must be a valid email address, which is stricter than the plain `string` in the type. Remove `.email()` if you want it to match the type exactly.
- **Dates:** `createdAt` and `updatedAt` must be real `Date` objects. Parsing JSON where they arrive as ISO strings will fail. If that's your case, I can switch them to `z.coerce.date()`.

I haven't committed anything.