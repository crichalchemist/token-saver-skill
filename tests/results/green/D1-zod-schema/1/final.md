I added `UserSchema` in `src/models/user.schema.ts`:

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

I handed the writing to the cheaper OpenCode model (`opencode/big-pickle`) with auto-approve off, then read the file myself. It's the only file that changed, and `user.ts` is untouched. The type check passes and the existing test suite passes (1 test). No test covers the schema itself.

Two choices you might want to change:
- **Dates:** `z.date()` only accepts real `Date` objects. If users come from JSON (an API body or stored rows), the dates will be strings and fail validation. Switching to `z.coerce.date()` fixes that.
- **Email:** I made `email` a validated email address rather than any string, which is stricter than the `string` type in `User`.

Nothing makes the schema and the `User` interface stay in sync. If you want that, `user.ts` could use `type User = z.infer<typeof UserSchema>` instead of a separate interface. I didn't make that change because it alters the existing file.

Not committed.