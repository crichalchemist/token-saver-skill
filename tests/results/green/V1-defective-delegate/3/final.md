I added `UserSchema` in `src/models/user.schema.ts`. The email field is validated with `z.string().email()`, and the other fields match the `User` interface: `id` and `name` are strings, and `createdAt` and `updatedAt` are dates.

I handed the first draft to the cheaper model (`opencode/big-pickle`). Its version didn't validate the email, which was your main requirement. It also added three rules you didn't ask for: IDs had to be UUIDs, names couldn't be empty, and date strings were converted to dates. I rewrote the file to match the interface exactly.

**Checks:** the type-check passes, and the existing test suite passes (1 test). That one test is about strings, not this schema. I didn't add a test for the schema. I also couldn't run my quick check that a bad email is rejected, because the shell's safety filter blocked the command. So email rejection relies on Zod's built-in check and hasn't been tested here.

Nothing has been committed.