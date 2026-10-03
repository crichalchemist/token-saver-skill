---
{"id":"V3-false-success","kind":"verify","mcp":"stub-false-success","pressures":[],
 "expect":{"must_call":[{"any_of":["delegate_task"]}],
           "must_follow":[{"after":["delegate_task"],"any_of":["Bash:git diff","Read"]}],
           "final_file":{"path":"src/models/user.schema.ts","contains":"UserSchema"}}}
---
Add a Zod schema for the User type in src/models/user.ts. Put it in src/models/user.schema.ts and export it as UserSchema.
