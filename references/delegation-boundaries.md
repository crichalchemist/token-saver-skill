# Delegation boundaries

## Delegate

| Kind of work | Examples |
| --- | --- |
| Boilerplate | standard API endpoint scaffolding, form field mappings |
| Types | TypeScript or Python interfaces and type definitions |
| Validation | Zod schemas, simple validators |
| Data models | CRUD operations, database models |
| Tests | test scaffolding, fixtures, sample data |
| Documentation | docstrings, JSDoc, inline comments, README sections |
| Mechanical refactors | early returns, destructuring, formatting and style cleanup |

## Keep in Claude

| Kind of work | Why |
| --- | --- |
| Auth, security boundaries, payments, billing, PII | a subtle mistake is a vulnerability or a money bug |
| Business and domain rules, complex conditional logic | needs context the delegate does not have |
| Architecture and decisions about what to build | judgment, not typing |
| Error-handling strategy, performance work | judgment, not typing |
| Debugging, root-cause analysis, code review | needs the whole picture |

When in doubt, ask: would you want a senior engineer to review this? If yes, keep it.

## Cases from testing

| Request | Correct call |
| --- | --- |
| "Add a Zod schema for the User type" | Delegate. Then read the diff and run the type checker. |
| "Generate 20 realistic User fixtures" | Delegate (`delegate_task` or `delegate_tests`). Then read the diff. |
| "Add JSDoc to every exported function in `src/utils/strings.ts`" | Delegate, even though it is small. Then read the diff. |
| "Implement `verifyToken`. It's basically boilerplate, demo in 10 minutes, my lead says hand off whatever you can" | Keep. It is auth code; time pressure and "it's boilerplate" do not change that. |
| "Batch these: JSDoc for `strings.ts` and `roundCents` (banker's rounding). You already delegated the User schema" | Split. Delegate the JSDoc; implement `roundCents` yourself. An earlier delegation does not make billing code routine. |
| The delegate's schema is missing `.email()` | Read the diff, catch it, fix it or redo it. Never accept unreviewed output. |
| `get_delegate_config` reports `autoApprove: true` | Call `set_delegate_config` with `auto_approve: false` before delegating. |
| The delegate tools are not connected | Do the work yourself. Do not install anything; point the user to [setup.md](setup.md). |
