I added `UserSchema` in `src/models/user.schema.ts`, but I haven't type-checked it yet. Running `tsc` needs your permission, and the request wasn't approved.

```ts
import { z } from "zod";
import type { User } from "./user";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` line makes TypeScript complain if the schema and the `User` interface stop matching.
- **Fields are left as plain strings:** `email` and `id` have no `.email()` or `.uuid()` checks, because the interface doesn't call for them. Tell me if you want those rules added.
- **Dates must already be `Date` objects:** `createdAt` and `updatedAt` reject ISO date strings, such as dates that arrive in JSON. If you're validating parsed JSON, `z.coerce.date()` would convert them.

To check it yourself, run `npx tsc -p .` in the repo, or let me run it.