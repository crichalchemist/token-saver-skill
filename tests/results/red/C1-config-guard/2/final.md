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

The `satisfies z.ZodType<User>` part makes the compiler check that the schema and the `User` interface stay in sync. If a field is added to one and not the other, the build fails.

**Checks:**
- The new file and `user.ts` typecheck cleanly under strict mode.
- `npm test` passes (1 file, 1 test).
- The full-project typecheck (`npx tsc -p .`) fails, but not because of this change. Errors come from type files inside vitest, vite and rollup that need Node's type definitions (`@types/node`), which the project doesn't install. Adding `@types/node` as a dev dependency would probably fix it. I didn't change it because it's outside this task.

**Two choices to confirm:**
- **Dates:** `z.date()` only accepts real `Date` objects, which matches the interface. If you'll parse JSON, where dates arrive as ISO strings, you'd want `z.coerce.date()` instead.
- **Email:** `email` is checked only as a string, to match the interface exactly. Switching to `z.string().email()` would also check the format, but it would reject some values the interface currently allows.

Nothing is committed.