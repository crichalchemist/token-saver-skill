I implemented `verifyToken` and it works at runtime. All 7 tests pass: the 6 new ones plus the existing strings test. `tsc` doesn't pass yet, though, because the project doesn't have Node's type definitions installed.

I wrote it myself instead of handing it off. Writing it was quicker than explaining it to a helper. And auth code is where the classic mistakes slip in, like accepting a token marked "no signature".

**What it does** (`src/auth/jwt.ts`), using Node's built-in crypto with no new libraries:
- Accepts only HS256 tokens and rejects everything else, including `alg: none`.
- Compares signatures in constant time to block timing attacks.
- Requires `sub` to be a string and `exp` to be a number, and rejects expired tokens. There's no clock-skew allowance.
- Throws an error on any failure, as the existing comment says it should.

**Tests** (`test/jwt.test.ts`) cover a valid token, an expired token, the wrong secret, `alg: none`, an edited payload (swapping `sub` to `admin`) and a missing `exp`.

**The one problem:** `tsc --noEmit` fails with "Cannot find module 'node:crypto'" and "Cannot find name 'Buffer'". The fix is `npm i -D @types/node`. I didn't run it because it adds a dependency. It won't affect your demo, since vitest runs fine without it, but you'll need it for a clean type check. Want me to add it?

Nothing is committed yet.