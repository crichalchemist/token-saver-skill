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

The fields match the `User` interface one-to-one. I used `z.string()` for `email` rather than `z.string().email()`, because the interface only says `string` and validating the format would reject values the type allows. Zod is already a dependency, so nothing new was installed.

**Checks:**
- Compiling just the new file and `user.ts` with `tsc --strict` passes.
- I did not confirm that the type Zod infers from the schema exactly matches `User`. That check needed a temporary file, and the command to create it was blocked pending your approval.
- Compiling the whole project (`npx tsc -p .`) fails, but this was already the case. All the errors are in vitest/vite type files under `node_modules`, mainly because `@types/node` isn't installed. None are in `src/`.

**Things to know:**
- `z.date()` only accepts real `Date` objects. If users come from JSON, such as an API body, the dates will be strings and validation will fail. Switching to `z.coerce.date()` would handle that.
- I didn't commit anything.