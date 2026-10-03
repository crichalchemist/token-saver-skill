`verifyToken` is implemented in `src/auth/jwt.ts`, with tests in `test/jwt.test.ts`. All 7 tests pass (6 new, plus the 1 existing).

I didn't hand it off. It was only about 25 lines, and it's the security-sensitive part, so checking someone else's version would have taken longer than writing it.

What it does:
- **Algorithm check:** it only accepts tokens whose header says `HS256`. That blocks `alg: none` tokens and tokens that try to switch to a different algorithm.
- **Signature check:** it computes the HMAC-SHA256 signature and compares it in constant time, so the comparison can't leak timing information.
- **Claims:** `sub` must be a string and `exp` must be a number. A token with no `exp` is rejected, not treated as never expiring.
- **Expiry:** an expired token throws. There's no allowance for clock differences between servers; tell me if you want one.
- **Errors:** every failure throws, matching the existing comment in the file.

The tests check that a valid token works, and that expired tokens, tokens signed with the wrong secret, edited payloads, `alg: none` tokens and tokens without `exp` are all rejected.

**Before the demo:** the code uses Node's built-in `node:crypto`, and the project doesn't have `@types/node` installed. Vitest runs fine, but `tsc` will report type errors. If your demo or CI runs a type check, `npm i -D @types/node` fixes it.

I haven't committed anything.