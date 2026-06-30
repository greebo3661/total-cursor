# total-cursor

Portable **Cursor agent stack** for fast installation on any machine where you use Cursor.
Installs globally to user scope (`%USERPROFILE%\.cursor\` on Windows, `~/.cursor/` on Linux/macOS).

Built from the full-cycle stack documented in [d:\\docker\\docs\\full-cycle-agent-stack.md](https://github.com/greebo3661/total-cursor) (source project: voice-bot / Docker platform).

## What's included

| Component | Count | Install target |
|-----------|-------|----------------|
| Skills | 42 | `~/.cursor/skills/` |
| Rules (`.mdc`) | 26 | `~/.cursor/rules/` |
| Agents | 6 | `~/.cursor/agents/` |
| Guard hooks | 3 | `~/.cursor/hooks/` + project `hooks.json` via bootstrap |
| spec-kit templates | 25 files | project `.specify/` via bootstrap |
| MCP example | github + playwright | `~/.cursor/mcp.json` (merge) |

Optional profile **`docker-voice-bot`**: AGENTS.md, voice-bot skill, voice-bot rule for the telephony project.

See [manifest.json](./manifest.json) for the full inventory and [ATTRIBUTION.md](./ATTRIBUTION.md) for upstream sources.

## Prerequisites

- **git** — clone this repo
- **node** — guard hooks and MCP servers (`npx`)
- **PowerShell 7+** (Windows) — for `install.ps1`, `bootstrap-project.ps1`, `verify.ps1`
- **python3** (Linux/macOS) — MCP merge in `install.sh`
- Optional: **uv** — if you want to refresh spec-kit CLI separately (`pip install uv`)

## Quick install (Windows)

```powershell
git clone https://github.com/greebo3661/total-cursor.git
cd total-cursor
pwsh -File .\install.ps1
pwsh -File .\verify.ps1
```

Restart Cursor. Set `GITHUB_PERSONAL_ACCESS_TOKEN` in `%USERPROFILE%\.cursor\mcp.json`.

### Bootstrap a project (hooks + spec-kit + optional profile)

```powershell
# Generic project: .specify/ + project hooks.json
pwsh -File .\bootstrap-project.ps1 -ProjectPath D:\myproject

# Voice-bot project overlay
pwsh -File .\bootstrap-project.ps1 -ProjectPath D:\docker -Profile docker-voice-bot
```

## Quick install (Linux / macOS)

```bash
git clone https://github.com/greebo3661/total-cursor.git
cd total-cursor
chmod +x install.sh
./install.sh
```

Project bootstrap on Linux: copy `bundle/specify/` to your project and render `bundle/cursor/hooks.user.json`
(replace `{{USER_CURSOR_HOME}}` with `$HOME/.cursor`).

## Install options

```powershell
.\install.ps1                  # merge mode (default)
.\install.ps1 -Overwrite       # overwrite existing skills/rules/agents/hooks
.\install.ps1 -SkipMcp         # skip mcp.json merge
.\install.ps1 -SkipHooks       # skip hooks copy
```

```bash
./install.sh --overwrite
./install.sh --skip-mcp
./install.sh --skip-hooks
```

## Cursor limitations (read this)

Per [Cursor Rules docs](https://cursor.com/docs/rules):

1. **Skills** — reliably loaded from `~/.cursor/skills/` (user scope). This is the primary install target.
2. **Rules** — official project rules live in `.cursor/rules/` inside each repo. Files in `~/.cursor/rules/` are an **unofficial workaround** (behavior varies by Cursor version). Alternative: **Remote Rule (GitHub)** pointing at this repo (Settings → Rules → Add Rule → Remote Rule).
3. **Hooks** — loaded from **project** `.cursor/hooks.json`. This pack installs hook **scripts** globally and `bootstrap-project.ps1` writes project `hooks.json` with absolute paths to `~/.cursor/hooks/`.
4. **MCP** — merged into `~/.cursor/mcp.json`. Replace `YOUR_TOKEN_HERE` before use.

## Verify

```powershell
pwsh -File .\verify.ps1
```

Runs hook smoke tests (secret warn, tab block) and `npx ecc-agentshield scan` on your user `.cursor` directory.

## Update on a new node

```powershell
cd total-cursor
git pull
pwsh -File .\install.ps1 -Overwrite
pwsh -File .\verify.ps1
```

## Repository layout

```
total-cursor/
├── install.ps1 / install.sh
├── bootstrap-project.ps1
├── verify.ps1
├── manifest.json
├── bundle/
│   ├── cursor/          # skills, rules, agents, hooks, mcp.json.example
│   └── specify/         # spec-kit project templates
└── profiles/
    └── docker-voice-bot/  # optional project overlay
```

## License / attribution

Upstream components retain their original licenses. See [ATTRIBUTION.md](./ATTRIBUTION.md).
Do not commit real tokens or `.env` files to this repository.
