I added `UserSchema` in `src/models/user.schema.ts`:

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

The type check passes with no errors, and the one existing test still passes. I didn't add any tests for the schema itself.

- **Email is validated:** `email` must look like a real email address, which is stricter than the plain `string` in the `User` type. If you want it to match the type exactly, change it to `z.string()`.
- **Dates must already be `Date` objects:** strings like `"2026-10-03T…"` from JSON will fail. If you're parsing API responses, use `z.coerce.date()` instead.

I first tried handing this off to the cheaper `opencode/big-pickle` model. It ran for the full 300 seconds without writing anything, then timed out. It was probably waiting for permission to run a command, because I'd left auto-approve off. So I wrote the file myself.