# Setting up opencode-delegate

The token-saver skill uses the `opencode-delegate` MCP server, which runs a cheaper model through OpenCode. Without it, Claude does the work itself.

## 1. Install OpenCode

```bash
npm i -g opencode-ai
```

OpenCode's free models (`opencode/*`, for example `opencode/big-pickle`) need no credentials. Run `opencode models` to see what your install can use.

## 2. Register the MCP server

Add this to `.mcp.json` at the root of your project:

```json
{
  "mcpServers": {
    "opencode-delegate": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "github:mryesiller/opencode-delegate-mcp#52440fd"],
      "env": {
        "NPM_CONFIG_USERCONFIG": "/dev/null",
        "OPENCODE_DELEGATE_CONFIG": "./.claude/opencode-delegate.json"
      }
    }
  }
}
```

- The server is not published on npm, so `npx` builds it from the pinned GitHub commit.
- `NPM_CONFIG_USERCONFIG` makes npm ignore your user `~/.npmrc` for this one server. npm 11 fails the git-dependency build with `EALLOWSCRIPTS` when that file sets `allow-scripts`, as the `opencode-ai` install advises. Side effect: custom registry and proxy settings from your user npmrc are also ignored for this server.
- Start `claude` from the project root. `${CLAUDE_PROJECT_DIR}` is not expanded in this `env` block, so the config path is relative to where `claude` starts. If the server cannot find the file it silently uses its defaults, which include `autoApprove: true`.

On native Windows (not WSL), `npx` must be launched through `cmd`, and the null device is `NUL`. This is the complete Windows variant:

```json
{
  "mcpServers": {
    "opencode-delegate": {
      "type": "stdio",
      "command": "cmd",
      "args": ["/c", "npx", "-y", "github:mryesiller/opencode-delegate-mcp#52440fd"],
      "env": {
        "NPM_CONFIG_USERCONFIG": "NUL",
        "OPENCODE_DELEGATE_CONFIG": "./.claude/opencode-delegate.json"
      }
    }
  }
}
```

## 3. Configure the delegate

Create `.claude/opencode-delegate.json`:

```json
{
  "defaultModel": "opencode/big-pickle",
  "autoApprove": false,
  "timeoutMs": 300000,
  "profiles": {}
}
```

Keep `autoApprove` set to `false`. With `false`, the delegate can still write files and run commands inside the `directory` it is given; `true` only lets it act outside that directory.

## 4. Check it

Restart Claude Code. It asks once whether to approve the project `.mcp.json` server; approve it. If you decline, `/mcp` shows the server as disabled and the skill falls back to Claude doing the work directly.

Run `/mcp`. `opencode-delegate` should be connected with five tools: `delegate_task`, `delegate_tests`, `list_models`, `get_delegate_config` and `set_delegate_config`.

## Troubleshooting

- `/mcp` shows `CONNECTION_CLOSED`, or the server log says `Permission denied`: the npx cache directories are hash-named, so find the directory under `~/.npm/_npx/` (on Windows, `%LocalAppData%\npm-cache\_npx`) whose `package.json` lists `opencode-delegate-mcp`, delete it, and restart Claude Code.
