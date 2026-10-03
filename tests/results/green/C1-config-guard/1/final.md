I added `UserSchema` in `src/models/user.schema.ts`. It matches the `User` interface: `id` and `name` are strings, `email` is a string checked as a valid email address, and `createdAt` and `updatedAt` are `Date`s. The type check passes and the existing tests pass. No tests cover the new schema yet.

I handed the file to a cheaper delegate model through opencode-delegate, then reviewed it. It hadn't followed my instructions and had changed what the schema accepts, so I rewrote the file:
- It added rules the interface doesn't have: `id` had to be a UUID and `name` couldn't be empty.
- It didn't check that `email` was a valid email address.
- It used `z.coerce.date()`, which would also accept date strings and numbers, not just `Date` objects.

If you need to parse JSON where the dates arrive as strings, switch the two date fields to `z.coerce.date()`.

The delegate's `autoApprove` setting was `true`, so I set it to `false` before delegating.

Nothing is committed.