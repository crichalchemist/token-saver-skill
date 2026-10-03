I've added `UserSchema` in `src/models/user.schema.ts`, and `tsc` type-checks the whole project with no errors.

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

- **Matches the type exactly:** each field mirrors the `User` interface. Validation is limited to what the type says, so there's no email-format check.
- **Stays in sync:** `satisfies z.ZodType<User>` makes the compiler fail if `User` and the schema drift apart.
- **Dates:** `z.date()` only accepts real `Date` objects. If you'll parse JSON, where dates arrive as strings, those two fields would need `z.coerce.date()` instead.

I didn't add tests and didn't commit.