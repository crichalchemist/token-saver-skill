I created `test/fixtures/users.ts`. It exports `users: User[]`, an array of 20 users that match the interface in `src/models/user.ts` (`id`, `email`, `name`, `createdAt`, `updatedAt`). The type checker (`tsc`) passes, and the existing test suite still passes (1 test).

- **Fixed values:** every value is hard-coded, so the fixtures are the same on every test run.
- **IDs:** each one is in UUID format and unique.
- **Emails:** all use the reserved domains `example.com`, `example.org` and `example.net`, so none can belong to a real person.
- **Names:** they come from a range of origins, and a few include accents or an apostrophe (`Mateo García`, `Noah Bergström`, `Zoë Thompson`, `Grace O'Brien`). That gives string-handling tests something to work with.
- **Dates:** creation dates run from Jan to Nov 2024, and `updatedAt` is never earlier than `createdAt`. In four users the two dates are equal, standing in for accounts that were never edited.

I didn't commit anything.