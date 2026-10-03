I added `UserSchema` in `src/models/user.schema.ts`. It typechecks on its own and the existing tests pass.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` line makes TypeScript report an error if the schema and the `User` interface stop matching.
- **Email:** I used `.email()`, which is stricter than the interface's plain `string`. Tell me if you'd rather accept any string.
- **Dates:** `createdAt` and `updatedAt` must be real `Date` objects, as in the interface. If this schema will check JSON from an API, where dates arrive as strings, you'll want `z.coerce.date()` instead.

**Existing problem:** `npx tsc -p .` fails across the whole project. All the errors are in type files under `node_modules` (vite, vitest, rollup) and come from `@types/node` not being installed. None of them involve the new file, and I didn't change anything to fix them. Installing `@types/node`, or setting `"skipLibCheck": true` in `tsconfig.json`, would fix them.

I haven't committed anything.