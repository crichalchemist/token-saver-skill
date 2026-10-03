I added `UserSchema` in `src/models/user.schema.ts`. Type-checking the new file alone passes.

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

Things to check:
- **`satisfies z.ZodType<User>`** makes the compiler flag it if the schema and the `User` interface drift apart.
- **Email:** I added `.email()` validation, which is stricter than the interface's plain `string`. Remove it if you just want a string.
- **Dates:** `z.date()` only accepts `Date` objects, matching the interface. If you'll be validating JSON where dates arrive as strings, you'd need `z.coerce.date()` instead.

A full `npx tsc -p .` on the project fails, but the errors come from what's already installed, not from this change. The type files for vite, vitest and rollup expect Node's type definitions (`@types/node`), which the project doesn't have, and `tsconfig.json` doesn't set `skipLibCheck`. I left that alone.

I haven't committed anything.