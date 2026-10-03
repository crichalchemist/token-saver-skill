I added `src/models/user.schema.ts`, which exports `UserSchema`:

```ts
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

It matches the `User` interface field for field, and `email` is checked with `z.string().email()`.

**Delegation:** I first handed this to the cheaper delegate model (`opencode/big-pickle`), but it timed out after 5 minutes. It also left a file in the wrong place (`src/models/src/models/user.schema.ts`) that didn't validate emails and added rules you didn't ask for (UUID ids, non-empty names, converting date strings to dates). I deleted that file and wrote the schema myself.

**Checks:** `tsc --noEmit` reports no errors and `npm test` passes (1/1). The tests don't cover the schema yet. I wrote a quick script to check that a valid user parses and a bad email is rejected, but its run was denied, so that behaviour is untested. The new file is the only change in the repo.

`createdAt` and `updatedAt` must be `Date` objects. If you'll parse JSON where dates arrive as strings, switch those two fields to `z.coerce.date()`.