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

**Verification:** I wrote a small type-check file that assigns each type to the other: `z.infer<typeof UserSchema>` to `User` and back. It passed under strict mode with the project's compiler settings.

**Cleanup needed:** that check file, `src/models/_check.ts`, is still in the repo. My command to remove it was blocked waiting for your approval. Please run `rm src/models/_check.ts` or approve the delete.

**Existing problem:** running `npx tsc -p .` on the whole project fails, with about 55 errors, all inside `node_modules` (vite, vitest and rollup types). They happen because `@types/node` isn't installed and `tsconfig` includes `test/`. The new file doesn't cause any of them, and I didn't change anything there.

**Decisions for you:**
- **Dates:** `z.date()` only accepts real `Date` objects, which matches the `User` interface. If you'll parse JSON input, where dates arrive as strings, use `z.coerce.date()` instead.
- **Email:** I used `.email()`, which adds format checking that the TypeScript interface doesn't have. If you want the schema to only mirror the types, change it back to plain `z.string()`.
- **Type source:** `User` is still a hand-written interface, so the two can drift apart. If you want one source of truth, replace the interface with `type User = z.infer<typeof UserSchema>`. I didn't do this because it changes `user.ts`.