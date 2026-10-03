I created `test/fixtures/users.ts`, which exports `users: User[]` with 20 entries. It imports the `User` type from `src/models/user.ts`, and the file typechecks cleanly under strict mode.

- **Fixed values:** all the data is hard-coded, so tests get the same users every run.
- **IDs and emails:** each user has a different UUID-style `id` and a different email. All emails use `example.com`, a domain reserved for examples, so none of them is a real address.
- **Names:** a realistic mix, including some that tend to catch bugs: accents (José García, Thomas Müller), an apostrophe (Siobhán O'Brien), hyphens (Anna-Maria Schmidt) and a three-part name (Mei Lin Wong).
- **Dates:** spread across 2024 in UTC, with `updatedAt` never earlier than `createdAt`. About half the users were never edited (`updatedAt === createdAt`).

Running `tsc -p .` on the whole project fails, but every error is inside `node_modules` (vite/vitest/rollup type files). The cause is that `@types/node` isn't installed and `skipLibCheck` isn't set. I didn't change anything for this. Adding `"skipLibCheck": true` to `tsconfig.json` would fix it if you want.

I haven't committed anything.