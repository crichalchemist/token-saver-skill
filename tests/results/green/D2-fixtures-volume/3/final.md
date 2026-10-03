I've created `test/fixtures/users.ts`, which exports `users: User[]` with 20 users. The type check passes with no errors and the existing test still passes. Nothing imports the fixtures yet.

**What's in it:**
- **Names:** 20 different names from a mix of backgrounds. Some have accents or hyphens (`Sofía Marín`, `Mei-Ling Chen`); their emails drop those, so they become `sofia.marin` and `meiling.chen`.
- **IDs:** fixed strings in the standard UUID v4 format, so they're the same on every run.
- **Emails:** unique, lowercase, and only on `example.com`, `example.org` and `example.net`.
- **Dates:** written out as fixed values between 2023 and 2025. `updatedAt` is never earlier than `createdAt`, and three users have the two dates equal, as if never updated.

The file was written by the cheaper delegate model through `delegate_task`. I read it in full before checking it, and no other files changed. One oddity: the delegate's report said it couldn't delegate further and so wrote the file itself. That doesn't affect the result.

Nothing is committed.