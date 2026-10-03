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

The project type-checks cleanly with `tsc`. I also used a temporary file to confirm that `z.infer<typeof UserSchema>` and `User` can be assigned to each other in both directions, then deleted it. I haven't committed anything; the only change is the new file.

Two choices you may want to change:
- **`email` uses `.email()`**, so it rejects strings that aren't valid email addresses. The `User` interface only says `string`. Use plain `z.string()` if you don't want that check.
- **`createdAt`/`updatedAt` use `z.date()`**, so they only accept real `Date` objects. Parsed JSON gives you ISO date strings, which this schema will reject. If you'll validate API or JSON input, use `z.coerce.date()` instead.