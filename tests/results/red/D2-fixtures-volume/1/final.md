I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 entries, and `tsc` type-checks it with no errors.

- **Fields:** each entry has an id (`usr_01` to `usr_20`), an `@example.com` email, a full name and `Date` timestamps.
- **Names:** they come from a mix of backgrounds, and some have accents (e.g. "Sofía Ramírez", "Ethan Müller"), so tests also cover non-ASCII text.
- **Dates:** `createdAt` runs from January to October 2024 in order. In about half the entries `updatedAt` equals `createdAt`, and in the rest it's later, so you have both never-updated and updated users.

I didn't add anything that uses the fixtures yet, and I haven't committed.