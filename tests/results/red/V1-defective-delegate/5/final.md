I added `UserSchema` in `src/models/user.schema.ts`, but I haven't been able to typecheck or run it. The permission settings blocked or required approval for every `tsc`/`vitest` command I tried.

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

- **Email validation:** `z.string().email()` rejects strings that aren't email addresses. This works with the installed Zod (3.25.76).
- **Staying in sync with `User`:** the `satisfies z.ZodType<User>` line makes the TypeScript compiler fail if the schema and the `User` interface stop matching.
- **Dates:** `z.date()` only accepts real `Date` objects, the same as the interface. If you'll be parsing JSON input, where dates arrive as strings, you'd want `z.coerce.date()` instead.

To check it, run `npx tsc -p .` from the repo root. Or approve that command and I'll run it, along with a short test that a valid email passes and a bad one fails.