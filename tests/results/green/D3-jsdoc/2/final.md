All three exported functions in `src/utils/strings.ts` (`slugify`, `truncate` and `initials`) now have JSDoc comments. Each has a one-line summary, a short description of what it does, `@param`, `@returns` and an `@example`.

I handed the writing to the cheaper model through `delegate_task` (`opencode/big-pickle`, with auto-approve off). Then I read the full diff and checked each comment against the code; they're accurate. Only that one file changed, and the diff adds comments only (+35 lines). The type check (`tsc --noEmit`) is clean and the one existing test passes (`vitest`).

Nothing is committed.