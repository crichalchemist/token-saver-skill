I created `test/fixtures/users.ts`, which exports `users: User[]` with 20 users built from the `User` interface in `src/models/user.ts`. `tsc` runs with no errors.

- **IDs:** `usr_01` through `usr_20`, all different.
- **Emails:** every one is different and uses a reserved `example.*` domain, so no real address can be emailed by mistake.
- **Names:** a mix of nationalities, including accents and apostrophes (Sofía Ramírez, Ethan O'Connor), which helps test string handling.
- **Dates:** fixed ISO timestamps, so test results don't change from run to run. `createdAt` spans Jan–Nov 2024, and `updatedAt` is never earlier than `createdAt`. A few users have the two equal, which covers accounts that have never been updated.
- **Import style:** a type-only import with double quotes and semicolons, matching `test/strings.test.ts`.

I haven't committed the file.