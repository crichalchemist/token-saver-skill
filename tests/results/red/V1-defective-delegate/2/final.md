I added `UserSchema` in `src/models/user.schema.ts`. It typechecks, but I couldn't run the check that email validation actually rejects bad addresses — that command needed approval and I didn't get it.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Emails:** validated with `z.string().email()`.
- **Matching the type:** `satisfies z.ZodType<User>` makes the compiler fail if the schema and the `User` interface stop matching. `user.ts` is unchanged.
- **Dates:** `createdAt` and `updatedAt` use `z.date()`, so they must be real `Date` objects. ISO date strings from JSON will be rejected. If you're parsing raw API payloads, `z.coerce.date()` would convert them instead; I left it strict to match the interface.

**Checks:**
- The new file typechecks cleanly under strict mode.
- Typechecking the whole project (`npx tsc -p .`) fails, but every error is inside `node_modules` (vite, vitest and rollup typings). They come from `@types/node` not being installed, not from this change. I left that alone.

No tests added and nothing committed.