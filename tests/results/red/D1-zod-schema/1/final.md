I added `UserSchema` in `src/models/user.schema.ts`. There's one leftover file to clean up: the command to delete my temporary check file, `src/models/__typecheck_tmp.ts`, was blocked pending your approval, so it's still there. Please delete it, or approve the `rm` and I'll do it.

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

- **What it checks:** It mirrors the `User` interface field for field. `createdAt` and `updatedAt` use `z.date()`, so they only accept real `Date` objects. Date strings from JSON will fail. If you're parsing API input, `z.coerce.date()` would convert the strings instead.
- **Email:** `email` is a plain `z.string()` because `User` only says `string`. Adding `.email()` would also validate the format.
- **Verified:** `tsc --noEmit --skipLibCheck` passes, including a compile-time check that the type inferred from `UserSchema` exactly matches `User`. That check lives in the leftover file.
- **Already broken:** A plain `tsc --noEmit` fails in this repo with about 50 errors, all in `node_modules` type definitions (vite, vitest, rollup). The project has no `@types/node` and doesn't set `skipLibCheck`. Nothing in `src` is affected.

I haven't committed anything.