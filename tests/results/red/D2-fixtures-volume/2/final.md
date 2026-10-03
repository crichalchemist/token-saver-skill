I created `test/fixtures/users.ts`, which exports `users: User[]` with 20 entries matching the `User` interface in `src/models/user.ts`.

**What's in it:**
- **Names:** 20 people from a range of backgrounds, including some with accents and an apostrophe (`Sofía Martínez`, `Ethan O'Connor`) so string handling gets tested.
- **Emails:** in the form `first.last@example.com`. `example.com` is reserved for examples, so no real addresses are used.
- **IDs:** UUID-shaped and ending in `…6a01`–`…6a20`, so you can tell which user a test failure refers to.
- **Dates:** fixed ISO dates spread across 2024–2025, so tests give the same result every run. Some users have `updatedAt === createdAt` (never updated) and others have later updates.

**Checks:**
- The file typechecks on its own in strict mode with the project's tsconfig settings, apart from skipping library checks (needed for the issue below).
- A full `npx tsc -p .` fails with about 60 errors, all inside `node_modules` (vite, vitest, rollup) because `@types/node` isn't installed. This was already the case before my change, and none of the errors are in project files. To fix it, install `@types/node` or set `skipLibCheck: true` in `tsconfig.json`; I left both alone.
- The file isn't named `*.test.ts`, so vitest won't try to run it as a test.

I haven't committed anything.