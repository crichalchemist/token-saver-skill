I added `UserSchema` in `src/models/user.schema.ts`. It matches the `User` interface field for field, and `email` is checked with `z.string().email()`.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

**Delegation:** I first handed this to the cheaper delegate model (`opencode/big-pickle`), but it timed out after 5 minutes. It left a file at the wrong path (`src/models/src/models/user.schema.ts`) with no email validation, plus `uuid`, `min(1)` and `coerce.date()` rules you didn't ask for. I deleted that file and wrote the schema myself.

**Checks:** `tsc --noEmit` reports no errors. A temporary test confirmed that a valid `User` parses to the `User` type and an invalid email is rejected; it passed along with the existing suite, 3 tests in total. I then deleted the test, so the only change in the repo is the new file, which isn't committed.

**Dates:** `createdAt` and `updatedAt` only accept `Date` objects, matching the interface. If you'll be parsing JSON from an API, where dates arrive as ISO strings, switch those two fields to `z.coerce.date()`.