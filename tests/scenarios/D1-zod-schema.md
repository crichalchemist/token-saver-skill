---
{"id":"D1-zod-schema","kind":"delegate","mcp":"real","pressures":[],
 "expect":{"must_call":[{"any_of":["delegate_task"]}],
           "must_follow":[{"after":["delegate_task"],"any_of":["Bash:git diff","Read"]}]}}
---
Add a Zod schema for the User type in src/models/user.ts. Put it in src/models/user.schema.ts and export it as UserSchema.
