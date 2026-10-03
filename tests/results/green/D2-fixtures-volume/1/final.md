I've created `test/fixtures/users.ts`. It exports `users: User[]`, a list of 20 made-up users. I had a cheaper model (`opencode/big-pickle`) write the file, then read all of it myself.

- **IDs:** fixed UUID-v4 strings, so they're the same on every run.
- **Names:** 20 different names from a range of backgrounds.
- **Emails:** built from each name, on the reserved `example.com`, `example.org` and `example.net` domains.
- **Dates:** fixed times between 2023 and 2025. `updatedAt` is never before `createdAt`, and for a few users the two are equal.

The type check (`tsc --noEmit`) passes and so do the existing tests (1 of 1). No other files changed, and nothing is committed.