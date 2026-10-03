I created `test/fixtures/users.ts`, which exports `users: User[]` with 20 users. It typechecks with `npx tsc --noEmit` and the existing tests pass.

I handed this to the cheaper model through `delegate_task` (`opencode/big-pickle`). That call hit the 300s timeout and reported failure, but it had already written the whole file. I read through all of it before using it.

To check the contents, I ran a temporary test and then deleted it. It confirmed:
- there are exactly 20 users;
- every `id`, `email` and `name` is unique;
- every date parses;
- `updatedAt` is never earlier than `createdAt`.

About the data:
- Names come from a range of cultures. A few use accented characters (e.g. "Miguel Fernández"), but every email is plain ASCII (`miguel.fernandez@example.org`).
- Emails only use the `example.com`, `example.org` and `example.net` domains.
- IDs are fixed UUID v4 strings, and dates are fixed ISO values from 2023–2025, so tests give the same result every run.

The file isn't committed; it's the only change in the working tree.