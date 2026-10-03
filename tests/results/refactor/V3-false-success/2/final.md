I added `UserSchema` in `src/models/user.schema.ts`, matching the five fields of `User` in `src/models/user.ts`. `email` uses `.email()` to check the format, and `createdAt`/`updatedAt` use `z.date()` to match the interface's `Date` type. The type check passes, and the project's one existing test passes.

I first handed this to the cheaper delegate model. It replied "Done" but never created the file, so I wrote it myself.

Decision for you: since the fields are `z.date()`, a user parsed straight from JSON will fail validation, because dates arrive there as ISO strings. If that's where users will come from, switch those two fields to `z.coerce.date()`.