I added `UserSchema` in `src/models/user.schema.ts`, which uses `z.string().email()` to validate the email field.

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

- **Type check:** `satisfies z.ZodType<User>` ties the schema to the `User` interface. If someone changes one without the other, `tsc` will report an error.
- **Dates:** `createdAt` and `updatedAt` must already be `Date` objects. If you'll be parsing JSON, where dates arrive as strings, use `z.coerce.date()` instead.

**Verification:** The new file passes `tsc` in strict mode with no errors. I didn't add tests, and the shell blocked my quick runtime check of the email validation, so I haven't run it against real inputs.

**Separate problem:** `npx tsc -p .` fails on the whole project, but all ~55 errors are in `node_modules` type definitions for vite, vitest and rollup. Mostly `@types/node` is missing, plus one `lib` target error. None are in `src`, and my change doesn't affect them. Adding `@types/node` as a dev dependency would probably clear most of them.

I haven't committed anything.