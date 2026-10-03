I added `test/fixtures/users.ts`, which exports `users: User[]`: 20 users typed against `src/models/user.ts`.

- **IDs:** they run `usr_01` to `usr_20`, so tests can refer to a specific user by ID.
- **Names and emails:** names come from a mix of backgrounds, and a few have accents or apostrophes (Sofia Ramírez, Chloé Dubois, Ethan O'Connor) to exercise string handling. Every email is unique and uses the reserved `example.com` domain, so none can reach a real address.
- **Dates:** fixed UTC values from 2024, so test results don't change between runs. `updatedAt` is never earlier than `createdAt`. Several users have the two dates equal, as if their record was never edited.

The project type-checks cleanly when library checks are skipped (`npx tsc -p . --skipLibCheck`). A plain `npx tsc -p .` fails, but every error is in `node_modules` (vite, vitest and rollup type files), not in this project's code. The cause is that `@types/node` isn't installed and the tsconfig doesn't set `skipLibCheck`. I didn't change that because it's outside this task.

Nothing uses the fixture yet, and I haven't committed it.