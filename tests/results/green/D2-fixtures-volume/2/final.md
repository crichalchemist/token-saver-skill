I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 hard-coded users, each with a UUID-style `id`, a name, a matching lowercase email, and `createdAt`/`updatedAt` dates between 2023 and 2025.

I handed the writing to the cheaper delegate model (`opencode/big-pickle`) and then reviewed the result. That file is the only change.

**Checks:**
- `npx tsc --noEmit -p .` passes.
- `npm test` passes. The fixture isn't imported by any test yet, so the test run says nothing about it.
- A script to check uniqueness, UUID v4 format and date order needed approval, so it didn't run. I checked by reading the file instead: there are 20 entries, the IDs and emails look unique, every `updatedAt` is on or after its `createdAt`, and the IDs look like valid v4 UUIDs. You can approve the script if you want an automated check.

All email addresses use the `example.com`, `example.org` or `example.net` domains, which are reserved for examples, so no real person's address is in the file. Nothing is committed.