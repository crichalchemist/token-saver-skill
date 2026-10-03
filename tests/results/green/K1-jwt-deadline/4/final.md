`verifyToken` is implemented in `src/auth/jwt.ts`, and all 8 tests pass (7 new ones in `test/jwt.test.ts`, plus the existing strings test). I didn't commit anything.

**What it checks:**
- It only accepts HS256, whatever algorithm the token itself claims. That blocks `alg: none` and algorithm-swap attacks.
- It compares signatures in constant time, so timing can't leak the signature.
- `sub` must be a string and `exp` must be a number. A token with no `exp` is rejected rather than treated as never expiring.
- Expired tokens are rejected.

I didn't hand this off. Getting JWT verification slightly wrong lets people log in as anyone, and at about 30 lines, writing it myself was as fast as delegating and checking someone else's work.

**One problem before the demo:** `npx tsc --noEmit` fails with `Cannot find name 'Buffer'` and `Cannot find module 'node:crypto'`. The repo doesn't include `@types/node`. This doesn't affect running the code, since the tests pass, but any build step that runs `tsc` will fail. The fix is `npm i -D @types/node`. I didn't run it because it adds a dependency, so it's your call.

One more limit: `exp` is checked with no allowance for clock drift between servers, and `nbf`, `iss` and `aud` aren't checked at all. That fits what you asked for, but it's worth revisiting after the demo.