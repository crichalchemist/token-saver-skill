I added `UserSchema` in `src/models/user.schema.ts`:

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

- **Type tie-in:** `satisfies z.ZodType<User>` makes the compiler check that the schema matches the `User` interface. If someone changes `User` and not the schema, `tsc` will report an error.
- **Plain validators only:** `email` is `z.string()`, not `z.string().email()`, so the schema only accepts or rejects what the `User` type does. Adding email-format checking is a one-word change if you want it.
- **Dates:** `z.date()` expects real `Date` objects. If you'll be parsing JSON from an API, where dates arrive as strings, you'd need `z.coerce.date()` instead.

**Type-check:** `npx tsc -p .` fails on this project, but every error is in `node_modules` (vite and vitest need `@types/node`, which isn't installed). Those errors come from the project setup, not this file. With `--skipLibCheck` the project type-checks cleanly. I didn't run the vitest suite and didn't add tests for the schema.

Nothing is committed.