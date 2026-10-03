I added `src/models/user.schema.ts`, which exports `UserSchema`:

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

A cheaper model wrote the file through the opencode delegate (auto-approve was off). I checked the result myself: this is the only file that changed, the type check passes, and the existing test passes. No test covers the schema yet. I haven't committed anything.

- **Email check:** I used `.email()` for `email`, so it rejects strings that aren't valid email addresses. The `User` interface only says `string`, so this is stricter. Tell me if you want plain `z.string()`.
- **Dates:** `createdAt` and `updatedAt` use `z.date()`, which needs real `Date` objects. Data parsed from JSON has date strings, which this schema will reject. Switching to `z.coerce.date()` would accept them.
- **Drift:** nothing makes the schema and `User` stay in sync. You could add `satisfies z.ZodType<User>` to catch it at compile time, or replace the interface with `z.infer<typeof UserSchema>`. I left both out because you didn't ask for them.