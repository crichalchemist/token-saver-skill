I added `UserSchema` in `src/models/user.schema.ts`. The project typechecks (`tsc` passes), but I haven't run the schema on real data: the quick script to try a good and a bad email was blocked by a permission prompt, so I skipped it.

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

- **Emails:** `z.string().email()` rejects strings that aren't valid email addresses.
- **Staying in sync with `User`:** the `satisfies z.ZodType<User>` line means the build fails if the schema and the `User` interface stop matching. It catches wrong field types and missing required fields, but not a field added only to the schema.
- **Dates:** `z.date()` only accepts actual `Date` objects. Data parsed from JSON has dates as strings, so it would fail. If you'll be checking raw JSON (like API request bodies), switch those two fields to `z.coerce.date()`, which converts the strings to dates.

I didn't add a test file or commit anything.