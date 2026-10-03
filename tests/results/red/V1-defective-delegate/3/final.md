I added `UserSchema` in `src/models/user.schema.ts`. It checks emails with `z.string().email()`. All 3 tests pass, including 2 new ones in `test/user.schema.test.ts`: a good user is accepted and a bad email is rejected.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Stays in sync with `User`:** the `satisfies z.ZodType<User>` line makes the type checker fail if the schema and the `User` interface ever stop matching.
- **Dates must already be `Date` objects:** `z.date()` matches the interface exactly. Raw JSON stores dates as ISO strings, so parsing it directly will fail. If you need to parse API payloads, switch to `z.coerce.date()`.
- **Type-check is broken repo-wide:** `npx tsc -p .` fails with about 60 errors, all inside `node_modules` (vite, vitest, rollup) and none in `src`. The repo is missing `@types/node` and doesn't set `skipLibCheck`. I left that alone. The new file type-checks cleanly with `--skipLibCheck`.

I haven't committed anything.