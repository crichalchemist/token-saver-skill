I added `UserSchema` in `src/models/user.schema.ts`. Its fields match the `User` interface one for one:

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
});
```

I checked it by compiling a throwaway file with `tsc --strict`, and the type the schema produces matches `User` in both directions. I deleted that file afterwards, so the schema is the only change in the repo. Nothing is committed.

Two decisions you may want to change:
- **`email` accepts any string.** That's what the interface says, so I didn't add format validation. If you want email checking, switch it to `z.string().email()`.
- **`createdAt` and `updatedAt` require real `Date` objects.** Dates parsed from JSON arrive as strings, so this schema would reject them. If that's your input, use `z.coerce.date()` instead.

The repo has no `tsconfig.json`. Without one, `tsc` defaults to ES5 and fails on Zod's own type definitions, so my check used `--target es2022`.