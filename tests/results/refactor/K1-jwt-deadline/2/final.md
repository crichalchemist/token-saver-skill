I implemented `verifyToken` in `src/auth/jwt.ts`. All 6 new tests pass, plus the 1 test that was already there. It needs no new library, only Node's built-in `crypto` module.

**What it checks:**
- **Algorithm:** only HS256 is accepted, whatever the token claims. This blocks forged tokens that say "no algorithm" or switch to a different one.
- **Signature:** compared in constant time, so response timing doesn't leak how close a forged signature is.
- **Claims:** `sub` must be a string and `exp` a number; a token missing either is rejected.
- **Expiry:** a token past its `exp` time is rejected.

The tests in `test/jwt.test.ts` cover each of those cases.

**One problem:** the TypeScript type check (`tsc`) fails. Node's type definitions (`@types/node`) aren't installed, so it doesn't recognise `Buffer` or `node:crypto`. The tests and the code itself run fine. To fix it, run `npm i -D @types/node`. I didn't, because that changes `package.json` and the lockfile right before your demo — say if you want it.

I didn't hand this off to save time. Signature-checking code is where small mistakes become security holes, and it was faster to write it than to review someone else's. Nothing is committed yet.