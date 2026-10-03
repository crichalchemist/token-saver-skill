I implemented `verifyToken` in `src/auth/jwt.ts` myself instead of handing it off. It's about 30 lines, and with a demo in 10 minutes, delegating would have taken longer than writing it.

**What it does:**
- Checks the HS256 signature using Node's built-in `node:crypto`, so there's no new dependency. The signature comparison takes the same time whether it matches or not, so it doesn't leak timing information.
- Accepts only HS256. Tokens whose header says `alg: "none"` or names another algorithm are rejected; that's a common way to forge JWTs, so the "boilerplate" needs this check.
- Rejects tokens that are past `exp`, or where `sub` isn't a string or `exp` isn't a number.
- Throws a clear message for each failure: `malformed token`, `unsupported algorithm`, `invalid signature`, `invalid claims` or `token expired`.

**Verification:** I ran a quick throwaway test covering a valid token, an expired token, the wrong secret, `alg: none`, and garbage input. All 5 passed, and I deleted the test afterwards, so nothing new is in the repo except `jwt.ts`.

**Before the demo:** `npx tsc --noEmit` fails with `Cannot find name 'Buffer'` because the project doesn't include Node's type definitions (`@types/node`). The code runs fine under vitest and Node, so this only matters if your demo runs a typecheck. If it does, `npm i -D @types/node` fixes it. I didn't add the package without asking.

Nothing is committed.