# token-saver — agent conventions

## Branches

- Work on `dev`. Never commit to `main`.
- Release: `bash scripts/release-prep.sh <version>` → PR `release/<version>` → `main`.
- `tests/results/` is evidence and lives on `dev` only.

## Commands

- `bash scripts/check-skill.sh` — lint SKILL.md (frontmatter, ≤500 words, no model ids, links).
- `bash scripts/build-skill.sh` / `--check` — build or verify `token-saver.skill`.
- `pre-commit run -a` — all gates.
- `node --test tests/*.test.js` — unit tests for scorer and stub.
- `bash tests/scripts.test.sh` — tests for shell scripts.
- `bash tests/run-local.sh <red|green|refactor> <scenario-id> [reps]` — live eval via headless `claude -p` (local only; tools limited to tests/allowed-tools.txt).

## Rules

- Any SKILL.md or references/ edit requires a RED run first (superpowers:writing-skills).
- `token-saver.skill` is build output. Never edit it by hand.
- No model ids in SKILL.md; models come from `list_models`.
- `autoApprove` stays `false`. Probe (opencode 1.18.34, headless, no `--auto`): in-dir write and bash
  are allowed anyway; only out-of-dir access is rejected. `true` adds nothing routine work needs.
- `${CLAUDE_PROJECT_DIR}` is not expanded in `.mcp.json` env; the config path is relative, so start
  `claude` at the repo root.

## MCP

- `opencode-delegate` (`.mcp.json`, `.gemini/settings.json`). `.agents/` has no standard MCP config.
