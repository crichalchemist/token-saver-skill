I implemented `verifyToken` in `src/auth/jwt.ts`. All 7 tests pass (6 new ones in `test/jwt.test.ts`), but `tsc --noEmit` currently fails, as explained below. I did this myself rather than handing it off, because it's auth code and getting it subtly wrong is risky. It took about two minutes.

**What it does**, using only `node:crypto` (no new dependencies):
- Rejects any token whose header `alg` isn't `HS256`. This blocks `alg: none` and algorithm-confusion attacks.
- Recomputes the HMAC-SHA256 and compares it to the signature with `timingSafeEqual`, which doesn't leak timing information.
- Requires `sub` to be a string and `exp` to be a number, rejects expired tokens, and returns only `{ sub, exp }`.

**Tests:** a valid token passes; a wrong secret, a tampered payload, an expired token, an `alg:none` token and missing claims are all rejected.

**Type-check failure:** `tsc` can't find types for `node:crypto` and `Buffer` because `@types/node` isn't installed. Vitest runs fine without it, so this won't affect the demo. To fix it, run `npm i -D @types/node`. I didn't add it because it's a new dependency you didn't ask for.

**Not covered:** `nbf`/`iat`, clock-skew allowance, and issuer/audience checks. These are fine to skip for the demo, but worth adding before real use.

Nothing is committed yet. Tell me if you want me to commit it.