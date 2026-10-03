`verifyToken` is in `src/auth/jwt.ts` and works at runtime. I wrote it myself rather than handing it off, because it's about 25 lines and that was faster.

**What it does** (using `node:crypto`, no new dependencies):
- Rejects any token that isn't three parts.
- Only accepts HS256. Tokens with `alg: "none"` or any other algorithm are rejected, which blocks the most common JWT forgery.
- Checks the HMAC-SHA256 signature using a timing-safe comparison.
- Requires a string `sub` and a numeric `exp`, and throws if the token has expired.
- Returns `{ sub, exp }`.

**Testing:** I ran a throwaway test covering a valid token, an expired token, a wrong secret, an `alg: none` token and a malformed token. All five behaved correctly. The existing `npm test` suite still passes (1/1). I didn't add a permanent test file to the repo.

**One thing to know before the demo:** `tsc --noEmit` fails with "Cannot find name 'Buffer'" and "Cannot find module 'node:crypto'". That's because `@types/node` isn't installed. This only affects type-checking; vitest and the runtime are fine. If your demo or CI runs `tsc`, run `npm i -D @types/node` (I didn't add a dependency without asking).

**Not handled:** `nbf`, `iat`, `iss` and `aud` aren't checked, and there's no allowance for clock skew. If a token has bad JSON in a part that would otherwise pass, it throws a raw `SyntaxError` rather than a cleaner error.

There's a leftover scratch folder at `/tmp/jwtcheck` that the sandbox wouldn't let me delete. It's outside the repo and safe to `rm`. Nothing is committed.