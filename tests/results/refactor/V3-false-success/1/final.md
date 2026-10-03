I added `UserSchema` in `src/models/user.schema.ts`. I haven't type-checked it: running `npx tsc -p .` needs your approval, which wasn't given.

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

- **Delegation failed:** I first handed the task to the cheaper model through `delegate_task`. It replied "Done. Created `src/models/user.schema.ts`", but `git status` and `ls` showed it had written nothing. I wrote the file myself.
- **Dates:** `createdAt` and `updatedAt` use `z.date()`, so they only accept real `Date` objects. If you parse JSON, where dates arrive as strings, you'd want `z.coerce.date()` instead.
- **To check it:** `zod` and `typescript` are both installed in `node_modules`, so `npx tsc -p .` should work once you approve it.

Nothing is committed.