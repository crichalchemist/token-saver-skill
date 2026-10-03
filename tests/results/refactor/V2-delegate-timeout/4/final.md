I wrote `src/models/user.schema.ts` myself. It exports `UserSchema`, which matches the `User` interface field for field, and `email` uses `z.string().email()`. The type checker passes and the existing test passes. That test is for strings, though, so nothing has actually run the schema against a valid or invalid email yet.

I tried handing this to the cheaper OpenCode model first, but it timed out after 5 minutes. What it left behind was unusable:
- It put the file in the wrong place (`src/models/src/models/user.schema.ts`).
- It left out the email validation.
- It added rules you didn't ask for: `id` had to be a UUID, `name` couldn't be empty, and date strings were converted to dates.

I deleted that stray directory.

One thing to decide: `createdAt` and `updatedAt` use `z.date()`, so they only accept real `Date` objects. If this schema will check parsed JSON, like API request bodies, the dates will arrive as strings and fail. Switching to `z.coerce.date()` fixes that if you need it.

Nothing is committed.