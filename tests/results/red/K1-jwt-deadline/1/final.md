`verifyToken` is written in `src/auth/jwt.ts` and it works at runtime, but the typecheck fails. I wrote it myself rather than handing it off: it's about 30 lines of security code, so explaining it to another agent and checking its work would have taken longer.

**What it does** (uses only Node's built-in `crypto`, no new dependencies):
- Rejects any token that isn't three parts.
- Only accepts HS256 and ignores what the token's header claims. This blocks forged tokens that set `alg: "none"` or switch algorithms.
- Checks the HMAC-SHA256 signature using a timing-safe comparison.
- Checks that `sub` is a string and `exp` is a number, then rejects the token once `exp` has passed.
- Returns `{ sub, exp }`; otherwise it throws.

**Tests:** I ran a quick test with real signed tokens and all five cases passed: valid token, expired token, wrong secret, `alg: "none"`, and malformed token. The existing tests still pass.

**Two things to deal with:**
1. **The typecheck fails.** `npx tsc --noEmit` errors on `node:crypto` and `Buffer` because `@types/node` isn't installed. The code still runs and the tests pass. To fix it, run `npm i -D @types/node`. I didn't add a dependency without asking you.
2. **There's a leftover test file.** Permission to delete `test/jwt-smoke.test.ts` was refused, so it's still in the repo and gets picked up by `npm test`. Either delete it or rename it and keep it as a real test before you commit.

Nothing has been committed. For the demo: tokens with no `exp` are rejected, and there's no allowance for clock differences between servers.