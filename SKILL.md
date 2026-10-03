---
name: token-saver
description: Use when a request includes routine, well-specified code of any size (a schema, types, fixtures, docstrings or JSDoc, boilerplate, a mechanical refactor), even alongside other work, and opencode-delegate tools such as delegate_task are listed, including as deferred tools.
---

# Token Saver

## Overview

The `opencode-delegate` MCP server hands routine work to a cheaper model. You brief it and review the diff instead of writing the code.

**Rule:** if `delegate_task` is in your tool list and the task is on the delegate list below, call `delegate_task`. Small tasks included. "Briefing takes longer than doing it" is not a reason to skip: the brief is a few lines, the review is one diff, and the point is saving your tokens, not this task's seconds.

## Before the first delegation

1. Call `get_delegate_config`.
2. If `autoApprove` is `true`, call `set_delegate_config` with `auto_approve: false` before any `delegate_task`. A missing config file silently defaults to `true`.

Never pass `auto_approve: true` to `delegate_task`.

## Delegate or keep

| Delegate | Keep in Claude |
| --- | --- |
| boilerplate, types, Zod schemas and validators, CRUD models, test fixtures and scaffolding, docstrings and JSDoc, README sections, formatting, mechanical refactors | auth, security, payments and billing, PII, architecture, business rules, debugging, performance, code review |

A request that mixes both: delegate the routine part and do the rest yourself; anything touching the Keep column stays with you even if it looks like boilerplate or is described as routine (e.g. an auth validator or a billing model). Details and worked cases: [delegation-boundaries.md](references/delegation-boundaries.md).

## Delegation step

1. Call `delegate_task` with:
   - `task`: the goal, the files to create or change, the conventions to match (name an example file), and the check that proves it is done.
   - `directory`: the absolute path of the narrowest directory that holds those files. The delegate writes files and runs commands inside `directory`.
   - `model`: omit it to use the configured default. To choose one, call `list_models`.
2. Run `git diff` as its own command, then open every new or changed file with Read. Do this after every delegation, before relying on the output.
3. Run the project's checks (type checker, tests).
4. Accept the result, fix small defects yourself, or redo the work if it is wrong. Tell the user what was delegated.

## If the tools are missing

If `delegate_task` is not in your tool list, do the work directly. Do not install or run OpenCode or the server. Mention [setup.md](references/setup.md) to the user once.

## Red flags

`delegate_task` is listed and you are about to Write or Edit a file for a delegate-list task without having called it. Stop and delegate.
