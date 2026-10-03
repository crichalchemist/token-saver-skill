I added `UserSchema` in `src/models/user.schema.ts`. It typechecks, and a quick test showed it accepts `a@b.co` and rejects `nope` as an email.

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

- **Kept in sync with `User`:** the `satisfies z.ZodType<User>` line makes the compiler fail if the schema and the `User` interface drift apart.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects. If you'll parse JSON, where dates arrive as text, they would need to be `z.coerce.date()` instead.

**Cleanup needed:** I couldn't delete my scratch test because the delete needed your approval. Please remove `test/_tmp_user_schema.test.ts`, or approve the delete and I'll do it.

**Existing problem (not from this change):** running `npx tsc -p .` on the whole project fails. The test files pull in vitest's types, which need Node's type definitions, and `@types/node` isn't installed. Only the two model files typecheck cleanly on their own.

Nothing is committed.