# HelloAGENTS v2（`helloagents_v2` Skill）

本仓库提供一个统一的开发/维护 Skill：`helloagents_v2/`。
它支持自动路由 + 端到端工作流 + **项目级命令权限**（`helloagents/config.toml`）。

English: `README.md`

---

## 部署 / 安装

### 1) 获取本仓库

```bash
git clone https://github.com/nightwhite/helloagents.git
cd helloagents
```

### 2) 安装 Skill（手动复制）

将仓库里的 `helloagents_v2/` 复制到你的 AI CLI 配置目录：

| 源目录 | 目标目录 |
|---|---|
| `helloagents_v2/` | `<CLI_CONFIG_ROOT>/skills/helloagents_v2/` |

常见 `<CLI_CONFIG_ROOT>`：
- Claude Code: `~/.claude/`
- Codex CLI: `~/.codex/`

示例（macOS/Linux，Claude Code）：

```bash
cp -R helloagents_v2 ~/.claude/skills/helloagents_v2
```

示例（macOS/Linux，Codex CLI）：

```bash
cp -R helloagents_v2 ~/.codex/skills/helloagents_v2
```

示例（Windows PowerShell）：

```powershell
Copy-Item -Recurse helloagents_v2 $env:USERPROFILE\.claude\skills\helloagents_v2
```

### 3) 重启并验证

重启你的 AI CLI，然后先**触发/进入 `helloagents_v2` Skill**（不同 CLI 的方式不同：选择 Skill、或在对话中显式调用 Skill 名称）。

显式调用 `helloagents_v2` Skill 后，再执行：

```
~help
```

---

## 项目级命令权限（推荐）

每个项目都可以用一个文件控制哪些命令允许执行：

- 路径：`<PROJECT_ROOT>/helloagents/config.toml`
- `PROJECT_ROOT` 默认等于你打开 CLI 的工作目录（cwd）

如果该文件不存在，Skill 会在执行任意命令前自动初始化默认配置（默认：全部命令允许）。

手动初始化（可选）：

```bash
mkdir -p helloagents
cp <CLI_CONFIG_ROOT>/skills/helloagents_v2/assets/templates/config.toml helloagents/config.toml
```

配置说明：
- `denylist`：默认允许全部命令；把高风险命令加入 `deny = ["~rollback", ...]` 即可禁用
- `allowlist`：只允许 `allow = ["~plan", "~review"]` 这些命令

---

## 常用命令（最小清单）

- `~help`：查看“当前项目允许的命令列表 + 每个命令说明”
- `~plan <需求>`：执行到方案设计并创建方案包（不进入开发实施）
- `~exec`：选择并执行 `helloagents/plan/` 下的方案包（支持处理未归档/未完成）
- `~auto <需求>`：从评估→分析→设计→开发全流程执行（受权限控制）
- `~review` / `~test` / `~validate`：审查 / 测试 / 验证
- `~rollback`：回滚（建议默认按项目禁用）

---

## 升级 / 卸载

升级：
- 用新版本覆盖 `<CLI_CONFIG_ROOT>/skills/helloagents_v2/`（或先删除再复制）
- 项目内的 `helloagents/config.toml` 会保留，不受影响

卸载：
- 删除 `<CLI_CONFIG_ROOT>/skills/helloagents_v2/`
