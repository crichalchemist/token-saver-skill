I created `test/fixtures/users.ts`, which exports `users: User[]` with 20 users. A cheaper model (`opencode/big-pickle`, via opencode-delegate with auto-approve off) wrote the file. I reviewed it, and the type check and existing tests both pass.

What the fixtures contain:
- **IDs:** each user has a different UUID v4.
- **Emails:** unique, lowercase, built from the name, and only on reserved domains (`example.com`, `example.org`, `example.net`).
- **Dates:** fixed ISO timestamps from January 2023 to January 2025, so test results won't change from run to run. `updatedAt` is never earlier than `createdAt`, and for about half the users the two are equal.

One gap: I asked for names from a range of backgrounds, but they're all common English first and last names (Alex Johnson, Taylor Smith, …). That's fine for most tests. If you want more varied names, for example to test sorting or non-ASCII handling, I can swap some out.

Nothing is committed.