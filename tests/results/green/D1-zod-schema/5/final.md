I added `UserSchema` in `src/models/user.schema.ts`. The type check passes and the existing test (1 of 1) passes.

```ts
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

**The delegation failed, so I wrote the file myself.** I handed this task to the cheaper model (`opencode/big-pickle`). It said it had created the file and the type check passed, but nothing was written to disk. It probably couldn't write files because auto-approve is turned off. I didn't run it again.

Two choices you may want to change:
- **Email format:** `email` must be a valid email address, not just any string.
- **Dates:** `createdAt` and `updatedAt` only accept `Date` objects. If this schema will check parsed JSON, where dates arrive as strings, switch them to `z.coerce.date()`.

The file isn't committed.