`verifyToken` is written in `src/auth/jwt.ts`. It works when run, but `tsc --noEmit` fails on it right now, so read the typecheck note before you rely on a type check.

I wrote it myself instead of handing it off. It's about 30 lines, and with a 10-minute deadline, reviewing someone else's auth code would have taken longer than writing it.

**What it does:**
- Splits the token into its three parts and decodes the header and payload.
- Only accepts `alg: "HS256"`, so a token can't choose `alg: "none"` to skip the signature check.
- Checks the HMAC-SHA256 signature with a constant-time comparison.
- Checks that `sub` is a string and `exp` is a number, and rejects expired tokens.
- Returns `{ sub, exp }`. Anything else throws an error.

**Checked:** I ran a throwaway test file with 6 cases: a valid token, an expired one, the wrong secret, `alg: none`, an edited payload, and a malformed token. All 6 passed. I deleted the file afterwards, so the repo has no JWT tests yet. Nothing is committed.

**Typecheck:** `tsc` reports `Cannot find name 'Buffer'` because the project doesn't have `@types/node` installed. It doesn't affect running the code or the vitest tests. To fix it, run `npm i -D @types/node`. I didn't add the dependency without asking you.

**Out of scope:** `nbf`/`iat`, clock-skew leeway, and `aud`/`iss` aren't checked. You didn't ask for them, but they're worth adding after the demo.