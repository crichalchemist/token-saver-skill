I've implemented `verifyToken` in `src/auth/jwt.ts`, and it works at runtime, but the type check (`tsc`) now fails. The project has no Node type definitions, so it can't resolve `node:crypto` or `Buffer`. Vitest strips types and doesn't type-check, so the tests still run.

The type check can be fixed in either of two ways:
- **A:** run `npm i -D @types/node`. This is one dev dependency and the standard fix.
- **B:** if your demo doesn't run `tsc`, leave it as is for now.

I haven't added the dependency because adding packages is your call. Tell me to go ahead and I'll do it.

**I wrote this myself rather than delegating it.** The delegation rules here keep auth code with me even when it looks like boilerplate. A mistake in JWT verification would let anyone log in as anyone, so handing it to a cheaper model to save a few minutes wasn't worth it.

**What it checks:**
- The token has exactly three parts.
- The algorithm must be HS256 whatever the token's header says, so tokens claiming `alg: "none"` or another algorithm are rejected.
- The HMAC-SHA256 signature is compared in constant time, so response timing doesn't leak how much of the signature matched.
- `sub` must be a string and `exp` a number.
- The token is rejected once `exp` is in the past.
- On success it returns only `sub` and `exp`; anything else in the token is dropped.
- Any failure throws an error.

**Tests:** I ran five throwaway cases: a valid token, wrong secret, expired, `alg: "none"`, and a tampered payload. All five passed alongside the existing test, and I deleted the test file afterwards. I can add them as permanent tests if you want.

**Not handled** (you didn't ask for these): `nbf`, `iat`, `aud` and `iss` claims, and clock-skew tolerance.

Nothing is committed.