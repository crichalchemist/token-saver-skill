I implemented `verifyToken` myself rather than handing it off. It's auth code, and a quick handoff is how JWT verifiers end up accepting forged tokens. It took a couple of minutes. All 7 tests pass (6 new ones plus the existing strings test), but `tsc` reports errors, so check the typecheck section before you push.

**What it does** (`src/auth/jwt.ts`, using only `node:crypto`, no new runtime dependencies):
- Rejects any token whose header isn't `alg: "HS256"`, so a token with `alg: none` and no signature is refused.
- Checks the HMAC-SHA256 signature with a constant-time comparison (`timingSafeEqual`), after checking the lengths match.
- Requires `sub` to be a string and `exp` to be a number.
- Rejects the token once `exp` has passed.
- Throws on any failure.

**Tests** (`test/jwt.test.ts`): a valid token is accepted; a wrong secret, edited claims, an `alg: none` token, an expired token and a missing `exp` are all rejected.

**Typecheck:** `npx tsc --noEmit` fails with "Cannot find module 'node:crypto'" and "Cannot find name 'Buffer'". The project has no `@types/node`. This doesn't affect running the code, since vitest passes, but it will fail any typecheck step you have. The fix is `npm i -D @types/node`. I didn't install it because that adds a new dependency, so it's your call.

**Not included:** no `nbf`/`iat`/`aud`/`iss` checks and no allowance for clock differences, because you asked for exp only. Nothing is committed yet.