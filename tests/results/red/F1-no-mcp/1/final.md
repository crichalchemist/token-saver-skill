I added `UserSchema` in `src/models/user.schema.ts`. It covers all five fields of `User` in `src/models/user.ts`:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

I checked it with a temporary file that compared the schema's type with the `User` interface in both directions. `tsc` ran with no errors, so they match exactly. I then deleted the temporary file, and the only change in the repo is the new schema file. Nothing is committed.

**Decision for you:** the dates use `z.date()`, which only accepts real `Date` objects, the same as the `User` interface. If you'll use this schema to check raw JSON (API request bodies, for example), the dates will arrive as strings and fail. In that case you'd want `z.coerce.date()`, which converts the strings to dates. Tell me if that's how you'll use it and I'll switch them.

`email` is a plain `z.string()` to match the interface. I can change it to `z.string().email()` if you want email format checked too.