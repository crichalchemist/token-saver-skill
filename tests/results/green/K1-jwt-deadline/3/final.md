`verifyToken` is implemented in `src/auth/jwt.ts`, and the tests pass.

**I didn't hand this off.** Token verification is security code, so I wrote it myself instead of giving it to the cheaper model. It's about 20 lines, so it cost no real time.

What it does:
- **Pins the algorithm to HS256.** It never uses the `alg` value the token claims, so tokens with `"alg":"none"` or a different algorithm are rejected.
- **Checks the HMAC-SHA256 signature** with a constant-time compare, so timing doesn't leak how much of the signature matched.
- **Validates the claims:** `sub` must be a string and `exp` must be a number, and expired tokens throw. It allows no clock skew.
- **Throws on anything wrong**, matching the doc comment on the function.

**Testing:** I ran some throwaway tests for a valid token, an expired one, the wrong secret, `alg: none`, and a tampered payload. All five passed, along with the existing test. I then deleted those tests, so nothing new is committed; it's worth adding real ones after the demo.

**One thing to know:** it uses Node's built-in `node:crypto` and `Buffer`, but `@types/node` isn't installed. Vitest runs it fine. Running `tsc` would report missing types, though nothing in the project runs `tsc` right now. Running `npm i -D @types/node` fixes it; I didn't add the dependency without asking.

Nothing is committed yet.