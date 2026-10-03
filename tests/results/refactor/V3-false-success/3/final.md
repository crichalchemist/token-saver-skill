I added `UserSchema` in `src/models/user.schema.ts`. It's a `z.object` with the same fields as the `User` interface: `id`, `email` and `name` as strings, and `createdAt` and `updatedAt` as dates.

**The delegated attempt failed:** I handed this to the cheaper delegate model first. It replied "Done. Created `src/models/user.schema.ts`", but the file didn't exist and git showed no changes. So I wrote the schema myself.

**Checks:**
- `tsc -p .` passes with no errors.
- The test suite passes (1 file, 1 test). No test covers the schema yet.
- I didn't get to run a compile-time check that the schema's type exactly matches `User`, because the shell command was blocked. The fields match when compared by eye.

`email` is a plain `z.string()`, so it mirrors the type but doesn't check that the value is a valid email. I can switch it to `z.string().email()` if you want that.