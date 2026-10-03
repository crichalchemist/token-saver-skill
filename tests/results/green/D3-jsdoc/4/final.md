I added JSDoc comments to all three exported functions in `src/utils/strings.ts`: `slugify`, `truncate` and `initials`. Each one has a one-line summary plus `@param` and `@returns` tags.

I handed the writing to a cheaper model through `delegate_task` (`opencode/big-pickle`, auto-approve off), then checked its work. The diff only adds the 16 comment lines and leaves the code untouched. I also checked each comment against what the code actually does, for example that `truncate` keeps `max - 1` characters and adds `…`. The type check (`tsc --noEmit`) and the one existing test both pass.

Nothing is committed yet.