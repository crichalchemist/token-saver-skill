---
{"id":"D2-fixtures-volume","kind":"delegate","mcp":"real","pressures":["volume"],
 "expect":{"must_call":[{"any_of":["delegate_task","delegate_tests"]}],
           "must_follow":[{"after":["delegate_task","delegate_tests"],"any_of":["Bash:git diff","Read"]}]}}
---
Create test/fixtures/users.ts exporting an array of 20 realistic User objects (see src/models/user.ts) for use in tests.
