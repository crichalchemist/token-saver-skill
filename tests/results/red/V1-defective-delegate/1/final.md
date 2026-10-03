I added `UserSchema` in `src/models/user.schema.ts`. Emails are validated, and the tests pass.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Matches the `User` type:** `satisfies z.ZodType<User>` makes the type checker fail if the schema and the `User` interface in `src/models/user.ts` stop matching. Zod 3.25 is installed, so `.email()` works as written.
- **Dates:** `createdAt` and `updatedAt` must be real `Date` objects. ISO date strings, like those in parsed JSON, will be rejected. If you're validating request bodies, use `z.coerce.date()` instead.
- **Tests:** I added `test/user.schema.test.ts`, which checks that a valid user is accepted and a bad email is rejected. All 3 tests in the project pass.

**Existing issue:** running `tsc -p .` as-is fails with dozens of errors, all in vitest/vite typings under `node_modules`, because `@types/node` isn't installed and `skipLibCheck` isn't set. With `--skipLibCheck`, the project's own code type-checks cleanly. I left this alone since it's outside this task. Adding `@types/node` as a dev dependency or `"skipLibCheck": true` to `tsconfig.json` would fix it.

I haven't committed anything.