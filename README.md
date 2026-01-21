# HelloAGENTS v2 (`helloagents_v2` skill)

This repo ships one unified dev/maintenance skill: `helloagents_v2/`.
It supports auto routing + end-to-end workflow + **per-project command permissions** via `helloagents/config.toml`.

中文：`README_CN.md`

---

## Install / Deploy (manual copy)

### 1) Get the repo

```bash
git clone https://github.com/nightwhite/helloagents.git
cd helloagents
```

### 2) Copy the skill into your AI CLI config directory

Copy `helloagents_v2/` to:

| Source | Target |
|---|---|
| `helloagents_v2/` | `<CLI_CONFIG_ROOT>/skills/helloagents_v2/` |

Common `<CLI_CONFIG_ROOT>`:
- Claude Code: `~/.claude/`
- Codex CLI: `~/.codex/`

macOS/Linux (Claude Code):

```bash
cp -R helloagents_v2 ~/.claude/skills/helloagents_v2
```

macOS/Linux (Codex CLI):

```bash
cp -R helloagents_v2 ~/.codex/skills/helloagents_v2
```

Windows PowerShell (Claude Code example):

```powershell
Copy-Item -Recurse helloagents_v2 $env:USERPROFILE\.claude\skills\helloagents_v2
```

### 3) Restart & verify

Restart your AI CLI, then **enter/trigger the `helloagents_v2` skill first** (how you do this depends on your CLI: pick the skill, or explicitly invoke the skill name in chat).

After explicitly invoking the `helloagents_v2` skill, run:

```
~help
```

---

## Per-project permissions (recommended)

Each project can allow/deny commands via:

- Path: `<PROJECT_ROOT>/helloagents/config.toml`
- `PROJECT_ROOT` defaults to your CLI working directory (`cwd`)

If this file is missing, the skill will auto-initialize it before running any command (default: allow all commands).

Manual initialization (optional):

```bash
mkdir -p helloagents
cp <CLI_CONFIG_ROOT>/skills/helloagents_v2/assets/templates/config.toml helloagents/config.toml
```

Modes:
- `denylist`: allow everything by default, disable risky commands in `deny = ["~rollback", ...]`
- `allowlist`: only allow commands listed in `allow = ["~plan", "~review"]`

---

## Common commands (minimal)

- `~help`: show allowed commands for this project + descriptions
- `~plan <request>`: run until design and generate a package (stops before develop)
- `~exec`: pick and run a package under `helloagents/plan/` (handles unarchived/incomplete)
- `~auto <request>`: run end-to-end (subject to rules & permissions)
- `~review` / `~test` / `~validate`: review / test / validate
- `~rollback`: rollback (recommended to disable per project)

---

## Upgrade / Uninstall

Upgrade:
- Replace `<CLI_CONFIG_ROOT>/skills/helloagents_v2/` with the new version
- Your project `helloagents/config.toml` stays intact

Uninstall:
- Delete `<CLI_CONFIG_ROOT>/skills/helloagents_v2/`
