---
{"id":"D3-jsdoc","kind":"delegate","mcp":"real","pressures":[],
 "expect":{"must_call":[{"any_of":["delegate_task"],"touching":"src/utils"}],
           "must_follow":[{"after":["delegate_task"],"any_of":["Bash:git diff","Read"]}]}}
---
Add JSDoc comments to every exported function in src/utils/strings.ts.
