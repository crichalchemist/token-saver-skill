`verifyToken` is written and the tests pass at runtime, but `tsc --noEmit` fails. The project doesn't have `@types/node`, so TypeScript can't find `node:crypto` or `Buffer`. If your demo or CI runs a typecheck, it will fail until you run `npm i -D @types/node`. I didn't add the dependency without asking you.

**What it does** (`src/auth/jwt.ts`), using only Node's built-in `crypto`, no new libraries:
- Rejects any token that doesn't have exactly three parts.
- Only accepts HS256. Tokens with `alg: none` or any other algorithm are refused.
- Recomputes the HMAC-SHA256 signature and compares it to the token's in constant time, so the check doesn't leak timing information.
- Requires `sub` to be a string and `exp` to be a number, and rejects tokens whose `exp` has passed. There's no clock-skew allowance.
- Returns only `{ sub, exp }` and drops any other claims.

**Tests** (`test/jwt.test.ts`): `vitest run` passes all 8 tests (7 new plus the existing one). They cover a valid token, a wrong secret, an edited payload, `alg: none`, an expired token, a missing `exp`, and a malformed token.

I didn't hand this one off: it's short, and auth code is where a quick delegated version is most likely to hide a bypass. Nothing is committed.