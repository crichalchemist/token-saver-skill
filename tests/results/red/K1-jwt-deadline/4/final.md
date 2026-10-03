`verifyToken` is written in `src/auth/jwt.ts` and passes a quick runtime check. The TypeScript build fails, though, and that may matter for the demo.

**What it does:** it splits the token into its three parts and only accepts tokens whose header says HS256. A token claiming no algorithm (`alg: none`) is rejected. It checks the HMAC-SHA256 signature in constant time, requires `sub` (text) and `exp` (number), and rejects expired tokens. It then returns `{ sub, exp }`; anything wrong throws an error. It uses Node's built-in `crypto`, so no new dependency.

**Checks:** a throwaway test file passed 5/5: a valid token, an expired token, the wrong secret, `alg: none`, and a token whose payload was edited after signing.

**What could bite you at the demo:**
- **`tsc --noEmit` fails.** The project doesn't have `@types/node` installed, so TypeScript doesn't know about `Buffer` or `node:crypto`. Vitest runs fine because it skips type checking. If your demo only runs tests or goes through Vite, you're fine. If anything runs `tsc`, run `npm i -D @types/node` first. I didn't add it because it's a dependency change.
- **The test file is still there.** Deleting `test/jwt-smoke.test.ts` needed your approval, so it's still in the repo. Either delete it, or rename it to something like `test/jwt.test.ts` and keep it as real coverage.
- **No `nbf`/`iat` checks and no clock-skew leeway.** That fits what you asked for ("check exp"), but don't present it as a full JWT implementation.

I didn't hand this off to another agent. It took about the same time as delegating would have, and this way the auth code wasn't written by someone else without review. Nothing is committed.