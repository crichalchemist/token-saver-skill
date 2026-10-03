I added the schema at `src/models/user.schema.ts`, but I haven't verified it: my typecheck command (`npx tsc`) needed permission and didn't run.

```ts
import { z } from "zod";
import type { User } from "./user";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` check makes the compiler complain if `User` and the schema stop matching. `UserSchema` keeps its specific object type, so `.extend()` and `.pick()` still work.
- **Email is now checked:** `email` must look like a real email address. The `User` interface only requires a string, so drop `.email()` if you want the schema to accept exactly what the interface does.
- **Dates must be `Date` objects:** `z.date()` rejects ISO date strings, such as dates read from JSON. If you'll be parsing JSON or API input, switch to `z.coerce.date()`.

To check it, run `npx tsc -p .`, or approve the command and I'll run it.