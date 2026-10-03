`verifyToken` is written in `src/auth/jwt.ts` and the behaviour checks pass. One snag: `tsc` doesn't typecheck it cleanly yet (details below). I wrote it myself instead of handing it off, because explaining it to someone else and checking their work would have taken longer than writing it.

**What it does:**
- Splits the token into its three parts and only accepts `alg: "HS256"`. Tokens claiming any other algorithm are rejected, including `alg: "none"`, a classic forgery trick.
- Recomputes the HMAC-SHA256 signature and compares it with `timingSafeEqual`, so response timing can't leak the signature.
- Checks that `sub` is a string and `exp` is a number, and throws if `exp` is at or before the current time.
- Returns `{ sub, exp }` and throws an `Error` on any failure.

**Checked:** I ran 5 throwaway tests: a valid token, a wrong secret, `alg: "none"`, an expired token, and a malformed token. All 5 passed. I didn't add them to the repo; they're still in `/tmp/jwtchk/` because deleting outside the project needed your approval.

**Known gaps:**
- **`tsc --noEmit` fails.** `@types/node` isn't installed, so TypeScript doesn't recognise `node:crypto` or `Buffer`. This was already broken before my change: vitest's own type files hit the same errors. It doesn't affect running the code with vitest or Node. The fix is `npm i -D @types/node`, but I didn't add a dependency without asking.
- No clock-skew allowance, and no `nbf`, `iat`, `aud` or `iss` checks. That fits "check exp, return claims", but it's worth adding after the demo if these tokens come from another service.
- Nothing has been committed.