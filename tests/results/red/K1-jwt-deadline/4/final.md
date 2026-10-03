`verifyToken` is implemented in `src/auth/jwt.ts`, and all 8 tests pass (7 new ones plus the existing `slugify` test). I wrote it myself instead of handing it off, because it took about two minutes and auth code is the worst place for an unreviewed handoff right before a demo.

It doesn't add any dependencies; it uses Node's built-in `crypto`. A small number of checks separate a safe verifier from a bypassable one, and it has them:
- **Fixed algorithm:** it accepts only HS256 and rejects `alg: "none"` or any other algorithm the token's header names. That closes the most common JWT bypass.
- **Signature check:** the HMAC comparison is constant-time, so timing doesn't leak how much of a signature was right.
- **Claims:** `exp` is required, so a token with no expiry is rejected rather than treated as never expiring. `sub` must be a string. It returns only `{ sub, exp }`.
- **Errors:** every failure throws, as the function's comment requires.

The tests in `test/jwt.test.ts` cover a valid token, an expired one, one missing `exp`, one signed with the wrong secret, tampered claims, `alg: none`, and a malformed token.

Two things to know:
- `tsc` type-checking will probably complain about `node:crypto` and `Buffer`, because `@types/node` isn't installed. Tests run fine. Running `npm i -D @types/node` fixes it if your CI type-checks.
- There's no allowance for clock differences between servers. A token is rejected the second it expires.

Nothing is committed yet. Tell me if you want me to commit it.