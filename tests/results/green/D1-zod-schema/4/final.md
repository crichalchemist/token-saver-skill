I added `UserSchema` in `src/models/user.schema.ts`. The type check passes, and the existing test suite (1 test) still passes. No test covers the schema itself yet.

```ts
export const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
  name: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) satisfies z.ZodType<User>;
```

- **Stays in sync with `User`:** `satisfies z.ZodType<User>` makes the type check fail if the schema and the `User` interface drift apart.
- **Email:** `email` uses `.email()`, so it rejects badly formatted addresses. The interface only says `string`, so this is stricter.
- **Dates:** `createdAt` and `updatedAt` use `z.date()`, so they only accept real `Date` objects. Data parsed straight from JSON has dates as strings and would fail. If you're validating API payloads, `z.coerce.date()` converts those strings to dates.

A cheaper model wrote the file through `opencode-delegate`. I checked its output and only changed the formatting, splitting its one-line object across several lines. `src/models/user.ts` is unchanged, and nothing is committed.