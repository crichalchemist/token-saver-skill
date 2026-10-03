I added `UserSchema` in `src/models/user.schema.ts`. It matches the `User` interface field for field: `id`, `email` and `name` are strings, and `createdAt` and `updatedAt` are dates. The `satisfies z.ZodType<User>` line means the compiler reports an error if the schema and the interface ever drift apart.

The new file type-checks cleanly when checked on its own with library type checks skipped. I didn't run it on sample data: running it through `tsx` needed your approval, so I skipped that.

**Existing problem:** running `npx tsc -p .` across the whole project fails with about 55 errors, all inside `node_modules` (vite, vitest, rollup). They come from `@types/node` not being installed and `skipLibCheck` not being set. None of them are in `src`, and I didn't change anything to fix them.

**Decision for you:** the schema accepts any string for `email`, because the interface only says `string`. If you want real email checking, change that field to `z.string().email()`. Also, `z.date()` only accepts actual `Date` objects. If this will check JSON from an API, where dates arrive as strings, you'd want `z.coerce.date()` instead.

I haven't committed anything.