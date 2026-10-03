I added `UserSchema` in `src/models/user.schema.ts`, and `npx tsc -p .` passes cleanly. I didn't run it against any data: my one runtime check was blocked at the permission prompt.

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

A few choices to check:
- **Kept in sync with `User`:** `satisfies z.ZodType<User>` makes the build fail if the schema and the interface stop matching. The interface is still the source of truth, and `user.ts` is unchanged.
- **Email format is checked:** `email` must look like a real address, not just any string. If you only want the type checked, change it to `z.string()`.
- **Dates must already be `Date` objects:** `z.date()` rejects ISO date strings, like the ones you get from `JSON.parse` or an API response. If you're validating JSON, `z.coerce.date()` will convert the strings for you.

I didn't add tests or commit anything.