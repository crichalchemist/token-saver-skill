I added `UserSchema` in `src/models/user.schema.ts`. I couldn't fully type-check it: the project-wide `npx tsc -p .` stops on type errors inside `node_modules` (vitest, vite and rollup types), and running `tsc` on just the new file was blocked at the permission prompt.

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

- **Kept in sync with `User`:** `satisfies z.ZodType<User>` makes TypeScript complain if the schema and the `User` interface stop matching. `User` stays the main type definition.
- **Email is checked more strictly:** `User.email` is just a `string`, but I used `.email()` so the schema also rejects badly formed addresses. Tell me if you'd rather it accept any string.
- **Dates must already be dates:** `z.date()` only accepts `Date` objects. Data coming from JSON has dates as strings, so you'd need `z.coerce.date()` there. I didn't change it because you didn't say where the data comes from.

The `node_modules` errors are there with or without my change and come from missing `@types/node` and `skipLibCheck` not being set. Running `npx tsc --noEmit --skipLibCheck -p .` should confirm whether the new file is clean. I haven't committed anything.