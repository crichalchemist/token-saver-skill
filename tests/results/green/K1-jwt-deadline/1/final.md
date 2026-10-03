I've written `verifyToken` in `src/auth/jwt.ts`, but I haven't tested it, and the project doesn't type-check yet because of a missing dependency.

**What it does** (uses `node:crypto` only, no new packages):
- Splits the token into its 3 parts and rejects anything else.
- Rejects any header `alg` other than `HS256`, so a token marked `alg: none` can't pick its own algorithm and skip the signature check.
- Recomputes the HMAC-SHA256 signature and compares it with `timingSafeEqual` (a constant-time check, so the comparison doesn't leak timing information).
- Requires `sub` to be a string and `exp` a number, and throws if `exp` is now or in the past.
- Returns `{ sub, exp }`.

**Not verified:**
- **Type-check fails:** `tsc` can't find `node:crypto` or `Buffer` because `@types/node` isn't installed. The code still runs under Node and vitest. To fix it, run `npm i -D @types/node`. I didn't add the dependency without asking you.
- **Not run yet:** I wrote a smoke test covering a valid token, an expired one, a wrong secret, `alg:none` and a malformed token. The commands to run it inside the repo were blocked at the permission prompt, so it never ran. It's at `/tmp/jwtsmoke.test.ts`, outside the repo. To run it, copy it into `test/` and change the import to `../src/auth/jwt.ts`.

**Limits:** It doesn't check `nbf`, `iat`, `aud` or `iss`, and it allows no clock skew. That matches "check exp, return claims", but tell me if anything downstream relies on those.

I haven't committed anything.