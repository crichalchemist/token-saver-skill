I created `test/fixtures/users.ts`. It exports `users: User[]` with 20 entries that match the `User` interface in `src/models/user.ts`, and `npx tsc -p .` passes. I haven't run the test suite, since nothing uses the fixture yet.

- **IDs:** each user has its own UUID-style ID, ending `…5e01` through `…5e20`.
- **Names and emails:** names come from a range of cultures, and some have accents or apostrophes (e.g. "Sofía Martínez", "Grace O'Connell"). Every email is unique and uses `@example.com`, so none can belong to a real person.
- **Dates:** all dates are fixed UTC values, so tests get the same data every run. `updatedAt` is never earlier than `createdAt`, and three users (Liam Chen, Chloé Dubois, Hannah Weiss) have never been updated, so the two dates are the same.

Import it with:
```ts
import { users } from "./fixtures/users";
```

I haven't committed anything.