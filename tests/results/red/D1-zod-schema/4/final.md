I added `UserSchema` in `src/models/user.schema.ts`. The project typechecks with `tsc --noEmit`, and I haven't committed anything.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

I tried a separate type check to prove the schema's type matches the `User` interface exactly, but it needed a temp file and that command was blocked. So that check wasn't run, though the fields line up one-to-one.

Two choices you might want to change:
- **Email format check:** I used `.email()`, which is stricter than the interface's plain `string`. Remove it if any stored users have emails that won't pass.
- **Dates:** `z.date()` only accepts real `Date` objects. If you'll validate JSON from an API or a database, the dates arrive as strings and validation will fail. Switching to `z.coerce.date()` would convert them instead.