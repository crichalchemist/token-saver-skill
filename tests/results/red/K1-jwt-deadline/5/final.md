`verifyToken` is written in `src/auth/jwt.ts`, and it works at runtime: a throwaway set of 6 tests all passed under vitest. TypeScript type-checking does not pass yet, though. I didn't hand it off to another agent, since it's a short, security-critical function and checking someone else's version would have taken longer than writing it.

**What it does:**
- **Splits the token into three parts** and fails if it isn't shaped like `header.payload.signature`.
- **Only accepts HS256.** If the header names any other algorithm, the token is rejected. This blocks the common `alg: "none"` trick where an attacker sends an unsigned token.
- **Checks the signature** with HMAC-SHA256, comparing in constant time so the check doesn't leak timing information.
- **Checks the claims:** `sub` must be a string and `exp` a number, and an expired token is rejected.

**Tested:** a valid token passes; an expired token, wrong secret, `alg: none`, an edited payload, and a missing `exp` are each rejected.

**Two things for you:**
1. **`tsc --noEmit` fails** with "Cannot find name 'Buffer'" because the project doesn't have `@types/node` installed. Vitest runs the code fine, so the demo won't break. The fix is `npm i -D @types/node`. I didn't run it because it changes your dependencies, so that's your call.
2. **The scratch test file is still at `test/jwt-scratch.test.ts`.** I wasn't allowed to delete it. Delete it, or keep it as a starting point for real tests.

Nothing is committed.