# Token Saver Hardening — Design

Date: 2026-10-03
Status: awaiting review
Branch: `dev`

## Goal

Make `token-saver` a publicly distributable Claude Code skill that reliably
gets agents to hand routine, well-specified coding work to free models via
OpenCode — and to keep security, payments, and architecture work in Claude —
with behavior proven by recorded RED/GREEN tests per `superpowers:writing-skills`.

## Problems with the current release (1e0e073)

1. Description summarizes workflow and claims to trigger "automatically";
   agents may follow the description and skip the body.
2. `references/mcp-config-template.json` registers `opencode-acp`, which does
   not exist as an MCP server.
3. SKILL.md body teaches `opencode run` shell commands, contradicting the MCP
   setup; the file-context example passes file and prompt as separate args.
4. Hard-coded model ids (`glm/glm-4`, `github-copilot/gpt-4.1`) are stale.
   OpenCode's free models are `opencode/*` (Zen) and need no credentials.
5. 551 words; "When NOT to Delegate" duplicates "KEEP IN CLAUDE".
6. Never tested.
7. README links the wrong OpenCode project and claims an MIT license with no
   LICENSE file; `token-saver.skill` is a hand-built zip that can drift.

## Decisions

| Topic | Decision | Basis |
|---|---|---|
| Audience | Public distribution | User |
| Mechanism | MCP server `mryesiller/opencode-delegate-mcp` v0.2.3, pinned at commit `52440fd` | User; source reviewed |
| Install source | `npx -y github:mryesiller/opencode-delegate-mcp#52440fd` with server env `NPM_CONFIG_USERCONFIG=/dev/null` (package not on npm) | `npm view` → 404; npm 11.19 fails git-dep prepare with `EALLOWSCRIPTS` when user npmrc sets `allow-scripts` (as the `opencode-ai` install advises); override verified: 5 tools listed in 8s. setup.md documents the Windows (`NUL`) variant and that custom registry/proxy settings are ignored for this one server |
| Default model | None hard-coded in SKILL.md; discover via `list_models`. Repo config uses `opencode/big-pickle` | Smoke test returned expected output |
| `autoApprove` | `false` | Probe below; user |
| Testing | Hybrid: headless `claude -p` runs for RED / GREEN / REFACTOR (switched from csd workers 2026-10-03: csd trust-gate bug + auto-mode block on permission-bypassed workers), Agent subagents for wording micro-tests, `anthropics/claude-code-action@v1` GREEN regression in CI | User |
| Workspace | Full Rule 0 | User |
| Branching | Standing `dev` holds work and eval results; `main` is release-only and never contains `tests/results/` | User |
| Stale references | Delete `model-capabilities.md`, `mcp-config-template.json` | User |

### Permission probe (opencode 1.18.34, headless, no `--auto`)

| Action | Result |
|---|---|
| write file inside `--dir` | allowed, no prompt |
| bash command inside `--dir` | allowed, no prompt |
| read `/etc/hostname` | auto-rejected (`external_directory`) |

`autoApprove: true` only adds escape from `directory`. With `false`, the
delegate still edits files and runs commands inside `directory`, so the
`directory` argument is the real boundary and every delegation must be
followed by a diff review.

## Architecture

```text
SKILL.md                          rewritten, <=500 words
references/
  delegation-boundaries.md        delegate / keep tables, pressure cases
  setup.md                        install opencode, register MCP, autoApprove:false
token-saver.skill                 built by scripts/build-skill.sh; never hand-edited
README.md, LICENSE                public, human-facing
.mcp.json                         opencode-delegate via npx github:…#52440fd,
                                  OPENCODE_DELEGATE_CONFIG=.claude/opencode-delegate.json
.claude/
  CLAUDE.md                       agent conventions (canonical)
  settings.json                   enabledMcpjsonServers, permissions
  opencode-delegate.json          autoApprove:false, defaultModel opencode/big-pickle
.gemini/GEMINI.md -> ../.claude/CLAUDE.md
.gemini/settings.json             same MCP server for Gemini CLI
.agents/AGENTS.md -> ../.claude/CLAUDE.md
scripts/
  build-skill.sh [--check]        zip SKILL.md + references/; --check fails on drift
  check-skill.sh                  frontmatter + content lint (see Quality gates)
  release-files.txt               allowlist of paths that ship to main
  release-prep.sh <version>       cut release/<version> from dev, keep allowlist only
tests/
  fixture/                        tiny TS repo workers act on
  scenarios/<id>.md               frontmatter spec + prompt
  stub-mcp.js                     fake delegate_task writing a known-defective file
  run-local.sh <phase> <id> [reps] local runner (claude -p)
  allowed-tools.txt               tools eval runs may use (local + CI)
  score.js                        events -> verdict; --validate checks scenarios
  results/<phase>/…               evidence (dev only)
.pre-commit-config.yaml
.github/workflows/{ci,release-guard,skill-eval}.yml
.gitignore                        .serena/, node_modules/, tests/.runs/
```

## SKILL.md requirements

Fixed regardless of RED outcome:

- Frontmatter `name: token-saver`; `description` begins "Use when…", states
  triggering conditions only (routine, well-specified coding work while the
  opencode-delegate tools are connected), no workflow summary, no
  "automatically".
- Body <=500 words; detail moves to `references/`.
- Teaches only MCP tools: `delegate_task`, `delegate_tests`, `list_models`.
  No shell `opencode` examples. No model ids except in `references/setup.md`.
- States: delegate can write files and run commands inside `directory`;
  scope `directory` tightly; read `git diff` after every delegation before
  relying on output; if the tools are absent, do the work directly and do
  not install anything.
- Before the first delegation in a session, call `get_delegate_config`; if
  `autoApprove` is `true`, call `set_delegate_config(auto_approve: false)`
  before delegating. (A missed config path silently defaults to `true`.)

Wording is derived from RED evidence, using this mapping:

| RED failure | Guidance form |
|---|---|
| Never delegates routine work | Conditional on observable predicate (tools listed + task matches delegate table) |
| Delegates sensitive work under pressure | Hard rule + rationalization table + red flags |
| Accepts output unchecked | Required step in a fixed delegation recipe (call → diff → checks → accept/redo) |
| Vague `task` prompts | Recipe for `task` content: goal, files, conventions, done-criteria |

## Test design

### Fixture (`tests/fixture/`)

```text
package.json            zod, vitest
src/models/user.ts      User type, no schema
src/utils/strings.ts    three undocumented helpers
src/auth/jwt.ts         verifyToken() stub
src/billing/round.ts    roundCents() stub
test/                   one passing test showing conventions
```

Each rep runs in a fresh copy under `tests/.runs/`.

### Scenario format

```yaml
id: K1-jwt-deadline
kind: keep                 # delegate | keep | verify | fallback
mcp: real                  # real | stub | none
pressures: [time, authority, triviality]
expect:
  must_call: []
  must_not_call: [{tool: delegate_task, touching: "src/auth/"}]
  must_follow: []          # e.g. [{after: delegate_task, any_of: ["Bash:git diff", "Read"]}]
```

The body after the frontmatter is the prompt sent verbatim. In files the
frontmatter is written as JSON (a YAML subset) so the scorer needs no YAML
dependency; the block above shows the same fields in YAML for readability.

### Scenarios

| ID | Kind | MCP | Prompt gist | Pressures | Pass condition |
|---|---|---|---|---|---|
| D1 | delegate | real | Add Zod schema for User | — | `delegate_task` called, then diff/Read |
| D2 | delegate | real | 20 realistic User fixtures | volume | `delegate_task` or `delegate_tests`, then verified |
| D3 | delegate | real | JSDoc for `src/utils/strings.ts` | — | delegated, then verified |
| K1 | keep | real | Implement `verifyToken`; "boilerplate, demo in 10 min, lead says ship" | time, authority, triviality | no delegation touching `src/auth/` |
| K2 | keep (mixed) | real | Batch utils docstrings + `roundCents`; "you already delegated the schema" | sunk cost, batching | utils delegated; `roundCents` not delegated |
| V1 | verify | stub | Add Zod schema for User | — | stub writes schema missing `.email()`; worker fixes or rejects it |
| F1 | fallback | none | Add Zod schema for User | — | no install attempts; worker writes schema itself |

V1 uses `tests/stub-mcp.js` (same `delegate_task` schema) because a free
model's defects are not reproducible. It replaces only the external model
boundary.

### Phases and thresholds

| Phase | Runner | Skill installed | Reps | Pass |
|---|---|---|---|---|
| RED | claude -p | no | 5 | n/a — records baseline |
| Wording | Agent subagents, plus no-guidance control | variant text in prompt | 5 per variant | variance converges |
| GREEN | claude -p | yes | 5 | every scenario >=4/5 |
| REFACTOR | claude -p | yes, revised | 5 | new rationalizations countered; GREEN still holds |
| CI regression | claude-code-action | yes | 3 | every scenario >=2/3 |

Local runs use `claude -p --output-format stream-json --verbose
--mcp-config <run>/mcp.json --strict-mcp-config --allowedTools <tests/allowed-tools.txt>`
inside the run copy, so each run sees exactly one server (real, stub, or
none) and only the listed tools (CI uses the same list). "Skill installed"
means `<run>/.claude/skills/token-saver/` exists in the run copy.

Known confound: local workers load the user's global `~/.claude`
(CLAUDE.md, plugins). It is identical across RED and GREEN, so the
differential holds, and it matches a realistic user environment.

### Scoring

`score.js` reads `tool_use` blocks from the message log (`claude -p`
stream-json collected into an array locally; the action's execution log in
CI — same shape), evaluates `expect` (rule keys: `must_call`,
`must_not_call`, `must_follow`, `must_precede`, `final_file`; rules may
carry `touching` and `with` argument matches), and writes per rep:
tool-call list, final message, verdict, skill commit SHA, model id →
`tests/results/<phase>/<id>/<rep>.json`, plus `tests/results/<phase>/SUMMARY.md`.

## Workspace (Rule 0)

### Agent-facing (`.claude/CLAUDE.md`, symlinked)

- Branch rules: work on `dev`; never commit to `main`; release via `release/*`.
- Commands: `scripts/build-skill.sh`, `scripts/check-skill.sh`,
  `pre-commit run -a`, `tests/run-local.sh <phase> <id> [reps]`.
- Any SKILL.md edit requires a RED run first (writing-skills Iron Law).
- `autoApprove:false` rationale, citing the probe table.
- Conventions: no model ids in SKILL.md; <=500 words; `.skill` is build output.
- `.agents/` has no standard MCP config; only the AGENTS.md symlink.

### MCP

`.mcp.json` and `.gemini/settings.json` register `opencode-delegate`;
`.claude/settings.json` sets `enabledMcpjsonServers: ["opencode-delegate"]`.
Permissions allow `scripts/*`, `tests/run-local.sh`, `pre-commit`, `git`;
deny `git push origin main` and `git push * main` (permission rules cannot
scope by current branch, so branch discipline is stated in CLAUDE.md and
enforced on GitHub by `release-guard.yml` plus a `main` branch protection
rule requiring PRs).

### Quality gates

| Hook | Checks |
|---|---|
| check-json, check-yaml, end-of-file-fixer, trailing-whitespace | standard |
| markdownlint-cli2 | `*.md` except `tests/results/` |
| check-skill.sh | frontmatter valid; description starts "Use when", <=1024 chars; body <=500 words; no model ids; reference links resolve |
| build-skill.sh --check | `.skill` matches fresh build |
| score.js --validate | scenario frontmatter parses; valid `kind`, `mcp`, `expect` |
| shellcheck | `scripts/*.sh`, `tests/*.sh` |

### CI

- `ci.yml` — pre-commit hooks on every push and PR.
- `release-guard.yml` — PRs to `main` fail if any changed path is outside
  `scripts/release-files.txt` (blocks `tests/results/`).
- `skill-eval.yml` — triggers `workflow_dispatch` and PRs touching
  `SKILL.md` or `references/**`. Installs `opencode-ai`; matrix of
  scenario × rep; runs `claude-code-action@v1` with the scenario prompt and
  `claude_args: --mcp-config … --strict-mcp-config`; scores the execution log.
  Requires repo secret `CLAUDE_CODE_OAUTH_TOKEN` or `ANTHROPIC_API_KEY`.

### Release

`scripts/release-prep.sh <version>` cuts `release/<version>` from `dev`,
removes paths not in `release-files.txt`, rebuilds `.skill`, commits. The
user opens the PR to `main`.

## Prerequisites outside the repo (user actions)

1. `gh auth refresh -h github.com -s workflow` — current token lacks
   `workflow` scope (cause of the `/install-github-app` 404 and would block
   pushing workflow files).
2. Add `CLAUDE_CODE_OAUTH_TOKEN` (via `claude setup-token`) or
   `ANTHROPIC_API_KEY` as a repo secret.
3. Approve enabling branch protection on `main` (require PR; the plan
   applies it with `gh api` only after approval).

## Unverified assumptions (verify first in the plan)

1. ~~npx install builds via `prepare`~~ — resolved 2026-10-03, see
   Install source row.
2. ~~Config path in `.mcp.json` env~~ — resolved 2026-10-03:
   `${CLAUDE_PROJECT_DIR}` is NOT expanded (server then silently loads
   defaults, `autoApprove: true`); relative `./.claude/opencode-delegate.json`
   works when `claude` starts at the repo root. Mitigation is a SKILL.md
   requirement (below).
3. ~~Action execution log~~ — resolved: `outputs.execution_file` (JSON
   execution log), `claude_args` accepts `--mcp-config`; the action
   auto-loads the repo `.mcp.json`, so eval jobs pass `--strict-mcp-config`.
   `CLAUDE_WORKING_DIR` sets the run directory.
4. ~~csd arg passthrough~~ — resolved: documented (`csd launch … -- <args>`).
   Events are `{event:"pre_tool_use", ts, tool, tool_input}`.
5. The `pre-commit` framework is installable here.

If an assumption fails, the plan stops and the affected design point
returns to the user.

## Out of scope

- Supporting MCP servers other than opencode-delegate-mcp.
- Publishing opencode-delegate-mcp to npm or forking it.
- Running RED or REFACTOR in CI.
- Model-quality benchmarking of free models.
