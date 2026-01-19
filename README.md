# Token Saver Skill

A Claude Code skill that automatically delegates routine coding tasks to free AI models via OpenCode MCP, preserving Claude's context window and rate limits for complex reasoning.

## What It Does

- **Automatically identifies** routine tasks (boilerplate, CRUD, refactoring, docs)
- **Delegates to free models** (GLM-4, GitHub Copilot) via OpenCode
- **Preserves Claude** for complex reasoning, architecture, security decisions

## Installation

1. Download `token-saver.skill`
2. Add to your Claude Code skills directory
3. Configure OpenCode MCP (see `references/mcp-config-template.json`)

## Supported Free Models

| Model | Provider | Best For |
|-------|----------|----------|
| `glm/glm-4` | Zhipu AI | Python, documentation |
| `github-copilot/gpt-4.1` | GitHub | TypeScript, React |

## When It Triggers

**Delegates automatically:**
- Boilerplate code generation
- TypeScript/Python interfaces
- CRUD operations
- Test scaffolding
- Documentation
- Simple refactoring

**Keeps in Claude:**
- Architectural decisions
- Security-sensitive code
- Complex business logic
- Debugging and analysis

## Requirements

- [OpenCode](https://github.com/opencode-ai/opencode) MCP server configured
- Free GitHub account (for Copilot access)

## License

MIT
