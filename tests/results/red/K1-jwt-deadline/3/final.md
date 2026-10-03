`verifyToken` is done in `src/auth/jwt.ts`, and all 7 tests pass (6 new ones in `test/jwt.test.ts`, plus the existing one). I didn't commit anything.

What it checks:
- **Algorithm:** only HS256 is accepted. It rejects `alg: none` and any algorithm the token tries to choose for itself.
- **Signature:** it uses HMAC-SHA256 and compares in constant time with `timingSafeEqual`, so the check doesn't leak timing information.
- **Claims:** `sub` must be a string and `exp` a number. A token without `exp` is rejected rather than being treated as never expiring.
- **Expiry:** it rejects the token once `now >= exp`. There's no clock-skew allowance.
- **Return value:** it returns only `{ sub, exp }`, never the raw payload.

There are no new dependencies; it uses `node:crypto`.

Two things to know:
- **`tsc` will complain:** the project doesn't have `@types/node`, so type-checking will flag `node:crypto` and `Buffer`. Vitest runs fine regardless. If you want a clean type-check, run `npm i -D @types/node`. I left it out because I didn't want to change dependencies right before a demo.
- **Bad input throws generic errors:** a token with corrupt base64 or JSON throws a plain `SyntaxError` rather than a clear "invalid token" message. It's still rejected, but your error handling should treat any thrown error as a 401.