I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 users, typed against `src/models/user.ts`.

- **Data:** each user has an id in UUID format, a name from a mix of nationalities (some with accents or apostrophes, like "Sofía Martínez" and "Ethan O'Connor"), and an email on a reserved `example.*` domain so nothing real is ever contacted. Ids and emails are all unique.
- **Dates:** every `createdAt` is no later than its `updatedAt`. A few users have the two equal, as for users who have never been edited.
- **Usage:** `import { users } from "./fixtures/users";`

**Type check:** the new file passes strict mode on its own, with library type checks skipped. The full project check (`npx tsc -p .`) still fails, but all those errors are inside `node_modules` and the file doesn't cause them. The project is missing `@types/node`, and `skipLibCheck` is turned off in `tsconfig.json`. I left that alone because it's outside this task. Adding `@types/node` or setting `"skipLibCheck": true` would make the full check pass.

I haven't committed anything.