I added `UserSchema` in `src/models/user.schema.ts`, but I wrote it myself because the delegated attempt failed.

I first handed the task to the cheaper model. It replied "Done. Created `src/models/user.schema.ts`", but when I checked, no file had been created and nothing in the repo had changed.

The schema has the same five fields as the `User` interface in `src/models/user.ts`:
- `id` and `name` are strings.
- `email` is a string that must be a valid email address.
- `createdAt` and `updatedAt` are dates.

The type check passes and the existing test suite passes (1 test). No test covers the new schema itself, and I didn't add one. I haven't committed anything.