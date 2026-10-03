I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 entries that match `src/models/user.ts`:

- **IDs:** each user has a unique UUID-style `id`.
- **Names and emails:** names come from a mix of backgrounds, and some include accents or punctuation (`Sofía Ramírez`, `Ethan O'Connor`, `Fatima Al-Sayed`). Emails are unique and use `@example.com`, so none of them are real addresses.
- **Dates:** fixed UTC values from 2024–2025, so tests give the same result every run. `updatedAt` is never earlier than `createdAt`. Five users have `updatedAt === createdAt` (never edited), so tests can cover that case.

To use it: `import { users } from "./fixtures/users";`

**Checks:**
- With `--skipLibCheck`, type-checking passes on `src` and `test`.
- A temporary sanity test passed: 20 users, all IDs and emails unique, valid dates in the right order. The existing `strings` test also passes.

**Two things need your attention:**
1. **Delete the temporary test yourself.** I was blocked from removing it, so `test/zz_tmp_check.test.ts` is still in the repo: `rm test/zz_tmp_check.test.ts`. If you'd rather keep it as a fixture check, rename it to something like `test/user-fixtures.test.ts`.
2. **Plain `tsc -p .` fails, and this was already the case before my change.** It reports about 55 errors, all inside `node_modules` (vite, vitest and rollup types), because `@types/node` isn't installed and `skipLibCheck` is off. Adding `@types/node` or `"skipLibCheck": true` would fix it; I didn't change either.

I haven't committed anything.