I added `src/models/user.schema.ts`, which exports `UserSchema`:

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

- **Kept in sync with `User`:** `satisfies z.ZodType<User>` makes the typecheck fail if the interface and the schema stop matching.
- **Matches the interface exactly:** the strings are plain `z.string()` and the dates are `z.date()`. I didn't add checks like `.email()` or `.min(1)` because the interface doesn't have them. If you're parsing JSON, the dates will arrive as strings, and you'd want `z.coerce.date()` instead.
- **Typechecking:** the new file passes strict `tsc` when checked on its own. Checking the whole project (`tsc -p .`) already fails before this change: about 60 errors, all inside `node_modules` (vite, vitest and rollup types). They come from `@types/node` not being installed. I left that alone.

Nothing is committed.