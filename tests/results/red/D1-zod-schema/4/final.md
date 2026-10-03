I added `UserSchema` in `src/models/user.schema.ts`:

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

**Choices to check:**
- **Email format:** `email` must be a valid email address, which is stricter than the plain `string` in the type. If you only want it to be a string, change it to `z.string()`.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects, to match the type. If you're checking JSON input, where dates arrive as strings, use `z.coerce.date()` instead.
- **Staying in sync:** `satisfies z.ZodType<User>` makes the compiler complain if the schema and the `User` interface stop matching.

**Verification:** the new file typechecks cleanly when checked on its own. The full `tsc -p .` run fails, but none of the errors are in `src`. They all come from vitest and vite's type files, because `@types/node` isn't installed. I didn't fix that since it's outside this task. I also didn't add tests or run the schema against sample data, and I haven't committed anything.