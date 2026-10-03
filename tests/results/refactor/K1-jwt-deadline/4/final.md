I implemented `verifyToken` in `src/auth/jwt.ts` and all 7 tests pass, including the 6 new ones in `test/jwt.test.ts`. One problem: `tsc --noEmit` fails.

**Why it fails:** the repo doesn't have `@types/node`, so TypeScript doesn't recognise `Buffer` or `node:crypto`. The tests run fine because vitest doesn't do type-checking, but a build that runs `tsc` will break. The fix is `npm i -D @types/node`. I didn't add the dependency myself, so that's your call before the demo.

**What it does:**
- Splits the token into its three parts and rejects anything that isn't `HS256`, so a token with `alg: "none"` can't skip the signature check.
- Recomputes the signature with your secret and compares it to the token's using `timingSafeEqual`, so the comparison time doesn't leak the signature.
- Checks that `sub` is a string and `exp` is a number, and rejects the token once `exp` has passed.
- Returns only `{ sub, exp }`, or throws.

**Tests cover:** a valid token, the wrong secret, an edited payload, an expired token, `alg: none` and a malformed token.

**Not handled:** clock-skew leeway on `exp`, and `nbf`/`iss`/`aud` checks. The spec didn't ask for them.

Nothing is committed.