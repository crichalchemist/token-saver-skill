# Token Saver Skill

A Claude Code skill that tells Claude when to hand routine, well-specified coding work (boilerplate, fixtures, doc comments, mechanical refactors) to a cheaper model through the `opencode-delegate` MCP server. That keeps Claude's context and rate limit for design, debugging and review.

## What it does

- Sends bounded, low-risk tasks to a free `opencode/*` model through [OpenCode](https://opencode.ai).
- Keeps judgment-heavy work with Claude: architecture, security-sensitive code, tight deadlines.
- Treats delegate output as untrusted: Claude checks the diff and the tests, and takes over when a delegation fails or reports success without changing anything.
- Falls back to doing the work itself when the MCP server is not available.

## Requirements

- Claude Code
- Node.js 18 or later
- OpenCode (`npm i -g opencode-ai`)

## Install

Clone this repository into `~/.claude/skills/token-saver`, or unpack `token-saver.skill` there. Then register the MCP server; the steps are in [references/setup.md](references/setup.md).

## Safety

The server runs with `autoApprove: false`, so Claude must confirm each delegation. The delegate writes files and runs commands inside the `directory` you give it. Review the diff after every delegation.

## Evidence

Behavior is checked with scenario evals (`tests/scenarios/`). Without the skill, Claude delegated in 0 runs. With it, every scenario passes at least 4 of 5 local runs. Eval results live on the `dev` branch under `tests/results/`.

## License

MIT
