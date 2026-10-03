I've added `UserSchema` in a new file, `src/models/user.schema.ts`:

```ts
import { z } from 'zod';

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

- **Who wrote it:** I handed this to the cheaper delegate model (`opencode/big-pickle`), then checked the result. The only change is the new file. `src/models/user.ts` wasn't touched.
- **Checks:** `tsc --noEmit` passes. The test suite passes, but its only test is in `test/strings.test.ts`, so nothing tests the new schema yet.
- **Email:** `email` uses `.email()`, so it's checked for a valid address format. That's stricter than the plain `string` in the interface.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects. Dates that arrive as strings, such as from parsed JSON, will fail. If that's your case, use `z.coerce.date()` for those two fields instead.

Nothing is committed.