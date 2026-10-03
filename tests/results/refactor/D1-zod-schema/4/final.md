I added `UserSchema` in `src/models/user.schema.ts`. It covers every field on the `User` interface:

```ts
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date()
});
```

The type check passes and so do the tests. There's only one existing test and it doesn't touch this schema, so nothing tests `UserSchema` yet. I handed the writing to a cheaper model through `opencode-delegate`, then reviewed the diff: it's just this one new file, and `user.ts` is unchanged.

Two choices you might want to change:
- **Email validation:** `email` is checked as an email address, which is stricter than the plain `string` in the interface.
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects. If you'll be validating JSON, where dates arrive as strings, those fields need `z.coerce.date()` instead.

I haven't committed anything.