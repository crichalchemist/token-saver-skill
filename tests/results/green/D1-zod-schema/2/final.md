I added `UserSchema` in `src/models/user.schema.ts`. It covers all five fields on the `User` interface:

```ts
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date()
});
```

A cheaper model wrote the file through `opencode-delegate`; I reviewed the diff and it's the only change. The type check passes, and the one existing test passes too, but no test covers the new schema.

Two things to know:
- **Email format is enforced.** `email` must look like a real address, which the `User` interface alone doesn't require.
- **Dates must be `Date` objects.** ISO strings, which is how dates arrive in JSON, will fail. If you're validating API payloads, I can switch those two fields to `z.coerce.date()`.

Nothing is committed.