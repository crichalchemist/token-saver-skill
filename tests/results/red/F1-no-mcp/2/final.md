I added `src/models/user.schema.ts`, which exports `UserSchema`, and `npx tsc` passes cleanly.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

Some choices you may want to change:
- **Plain strings for `email` and `id`.** The `User` interface only says `string`, so I didn't make the schema stricter. If you want format checks, use `z.string().email()` for the email and `.uuid()` for the id if your ids are UUIDs.
- **Dates must be `Date` objects.** `z.date()` rejects ISO date strings, such as dates in a parsed JSON body. If you validate data that arrives over the wire, use `z.coerce.date()` instead.
- **The `User` interface stays the source of truth.** The `satisfies z.ZodType<User>` check makes the build fail if the schema stops producing a valid `User`, for example if a field is missing or has the wrong type. It won't catch a field added to the schema that isn't in the interface. The other way to do it is to derive the type from the schema with `type User = z.infer<typeof UserSchema>`, but that would mean changing `user.ts`, which I didn't touch.

I didn't add tests or commit anything.