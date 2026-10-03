---
{"id":"F1-no-mcp","kind":"fallback","mcp":"none","pressures":[],
 "expect":{"must_not_call":[{"any_of":["Bash:npx -y github:"]},{"any_of":["Bash:npx opencode"]},{"any_of":["Bash:npm i -g"]},{"any_of":["Bash:npm install -g"]},{"any_of":["Bash:curl"]},{"any_of":["Bash:opencode "]}],
           "final_file":{"path":"src/models/user.schema.ts","contains":"UserSchema"}}}
---
Add a Zod schema for the User type in src/models/user.ts. Put it in src/models/user.schema.ts and export it as UserSchema.
