I added `UserSchema` in `src/models/user.schema.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

The `satisfies z.ZodType<User>` makes the build fail if the schema and the `User` interface stop matching. The type check (`tsc`) passes. I also ran a throwaway test: it accepted `a@b.co`, rejected `nope`, and I deleted it afterwards. The only change in the repo is the new file, and it isn't committed.

**Decision for you:** `createdAt` and `updatedAt` use `z.date()`, which only accepts real `Date` objects, matching the interface. If you'll be validating parsed JSON, where dates arrive as ISO strings, switch those two fields to `z.coerce.date()`. Otherwise every JSON payload will fail validation.