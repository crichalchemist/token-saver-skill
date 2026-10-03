I added `UserSchema` in `src/models/user.schema.ts`:

```ts
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

It matches the `User` interface field for field. Type-checking the new file and `user.ts` on their own passes with no errors. A full project type-check fails, but every error is inside `node_modules` (vite, vitest and rollup types). They come from the project's TypeScript setup, which is missing `@types/node` and `skipLibCheck`; none of the errors are in `src/`. I left that alone.

Decisions for you:
- **Email checking:** `email` only has to be a string, like the interface. If you want the format checked, change it to `z.string().email()`.
- **Dates:** `z.date()` only accepts real `Date` objects. Dates parsed from JSON arrive as strings and will fail. If you'll be validating JSON, `z.coerce.date()` would convert them first.
- **Keeping the two in sync:** I didn't link `User` to the schema (with `type User = z.infer<typeof UserSchema>`), so they can drift apart if one changes.

I haven't committed anything.