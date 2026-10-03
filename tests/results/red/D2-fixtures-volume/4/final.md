I've created `test/fixtures/users.ts`. It exports `users: User[]`, an array of 20 users built on the `User` interface in `src/models/user.ts`, and the project typechecks cleanly with `tsc`.

- **IDs:** each is a fixed UUID-style string ending in `…4e01` to `…4e20`, so you can find a user by its ID easily.
- **Names and emails:** a mix of international names, including accented ones (Sofía Martínez, Jonas Müller, Chloé Dubois) and one with an apostrophe (Ethan O'Connor). Every email is on `example.com`, so none can reach a real address.
- **Dates:** sign-ups run from January to December 2024, in order. `updatedAt` is never earlier than `createdAt`, and a few users have never been updated (both dates are the same).

I checked by eye that the IDs and emails are unique and the dates are in order; I didn't run a script to confirm it. I didn't commit the file.