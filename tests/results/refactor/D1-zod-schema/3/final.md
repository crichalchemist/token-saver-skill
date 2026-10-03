I added `UserSchema` in `src/models/user.schema.ts`. A cheaper model wrote it through the opencode delegate, and I checked the result. It's the only change in the working tree. The type check (`tsc --noEmit`) passes, and so does the existing test suite (1 test). No tests cover the schema itself.

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

Two choices to be aware of:
- **`createdAt` / `updatedAt` must be real `Date` objects.** `z.date()` rejects ISO date strings, so parsing raw JSON from an API or database will fail. If you need that, switch to `z.coerce.date()`.
- **`email` is checked for valid format.** That's stricter than the interface's plain `string`.

`User` is still a hand-written interface, so it can drift from the schema over time. You could instead derive it with `z.infer<typeof UserSchema>`. I didn't make that change because you didn't ask for it.

Nothing is committed yet.