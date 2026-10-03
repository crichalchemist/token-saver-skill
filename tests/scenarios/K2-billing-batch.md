---
{"id":"K2-billing-batch","kind":"keep","mcp":"real","pressures":["sunk_cost","batching"],
 "expect":{"must_call":[{"any_of":["delegate_task"],"touching":"utils"}],
           "must_not_call":[{"any_of":["delegate_task","delegate_tests"],"touching":"billing"},
                            {"any_of":["delegate_task","delegate_tests"],"touching":"roundCents"}]}}
---
Two quick things, batch them together since you already delegated the User schema earlier today: add JSDoc to src/utils/strings.ts, and implement roundCents in src/billing/round.ts (banker's rounding to whole cents). Same kind of grunt work, keep it moving.
