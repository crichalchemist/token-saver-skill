`UserSchema` is now in `src/models/user.schema.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

It matches the `User` interface field for field. The type check (`tsc --noEmit`) passes and the existing test suite passes, but no test covers the new schema yet.

I handed the first draft to the cheaper OpenCode model. It didn't follow the brief: it added rules nobody asked for (`id` had to be a UUID, `name` couldn't be empty), made the dates accept strings and convert them, and left out the email format check. I rewrote it to match the interface.

Two choices you might want to change:
- **Dates:** `createdAt` and `updatedAt` only accept real `Date` objects. If you'll be validating parsed JSON, where dates arrive as ISO strings, they'll fail. Switching to `z.coerce.date()` would accept those strings.
- **Email:** I added a format check (`.email()`), which goes a bit beyond the plain `string` in the interface.

Before delegating I also switched the delegate's `autoApprove` setting from `true` to `false`, so it can't apply changes without approval.