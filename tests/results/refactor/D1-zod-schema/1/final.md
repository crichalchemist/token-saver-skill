I added `UserSchema` in `src/models/user.schema.ts`. The type check (`tsc --noEmit`) passes with no errors, and the one existing test passes.

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

- **Who wrote it:** I handed the file to the cheaper model through opencode-delegate (`opencode/big-pickle`). That run hit its 300-second time limit, but it had already written the file. I read it and confirmed it matches the brief. `git status` shows it's the only change, and `user.ts` is untouched.
- **Dates:** `z.date()` only accepts real `Date` objects. If you'll be checking parsed JSON, where dates arrive as ISO strings, you'd want `z.coerce.date()` instead.
- **Duplicate type:** `User` is still a separate hand-written interface, so it could drift from the schema. If you want one source of truth, `user.ts` could become `export type User = z.infer<typeof UserSchema>`. I didn't make that change because you didn't ask for it.

Nothing is committed.