# 工具调用规则

本模块定义内部模块调用门控和文件/模板操作规范。

---

## 规则概述

```yaml
规则名称: 工具调用规则
适用范围: 所有涉及文件/模板操作和内部模块调用的场景
核心职责:
  - 定义内部模块调用入口和识别规则
  - 规范文件/模板操作格式和路径
  - 管理配置文件存在性检查与初始化生成
  - 定义错误恢复机制
```

---

<module_gate>
## 内部模块调用门控

**命名空间:** `helloagents`

**你的职责:** 通过路由机制统一调度内部模块，确保执行流程的完整性和可追溯性。

<module_identification>
内部模块识别规则:
1. 位于 {SKILL_ROOT}/ 目录下的 .md 文件
2. 通过 G4 路由机制触发
3. 通过命令触发词（~auto/~plan/~exec等）触发
4. 通过模块间相互引用触发
</module_identification>

**内部模块识别:**
- 位于 `{SKILL_ROOT}/` 目录下的 `.md` 文件

**调用入口:** G4 路由机制、命令触发词（~auto/~plan/~exec等）、模块间相互引用
</module_gate>

---

<script_validation>
## 文件/模板操作规范（无 scripts/）

### 路径基准

```yaml
SKILL_ROOT: {本 Skill 根目录}                 # SKILL.md 所在目录（即本包根目录）
TEMPLATE_DIR: {SKILL_ROOT}/assets/templates/  # 模板目录
```

### 调用格式

<file_ops_rules>
文件/模板操作规则:
1. 优先使用 TEMPLATE_DIR 的模板初始化
2. 路径使用双引号包裹
3. 项目根目录默认 cwd，可由用户指定
</file_ops_rules>

```yaml
注意: 本包不提供 scripts/；禁止调用 python 脚本。
执行方式: 直接按下方“能力对照（无 scripts/）”执行等价的文件/目录操作
```

### 项目路径确定规则

<path_determination>
项目路径确定推理过程:
1. 默认使用CLI当前打开的路径（cwd）
2. 用户明确指定时使用用户指定的路径
3. 上下文不明确时追问用户确认
</path_determination>

```yaml
优先级:
  1. CLI当前打开的路径（cwd）- 默认使用
  2. 用户在对话中明确指定的路径 - 覆盖默认
  3. 无法确定时 - 追问用户确认

AI判断流程:
  - 默认: 使用 cwd 作为项目根目录
  - 用户指定其他路径时: 使用用户指定的项目根目录
  - 上下文不明确时: 追问用户确认目标项目
```

### 能力对照（无 scripts/）

> 本包不提供 `scripts/`，以下能力由 AI 通过文件/目录操作直接实现。

```yaml
能力:
  ensure_config: 初始化 helloagents/config.toml（从模板复制）
  validate_package: 验证方案包结构/命名/任务状态
  project_stats: 统计项目规模（文件数/行数/模块数）
  create_package: 创建方案包目录与模板文件
  list_packages: 扫描 plan/ 目录列出方案包
  migrate_package: 迁移方案包到 archive/ 并更新索引
  upgrade_wiki: 扫描/升级知识库结构（按模板写入）
```

### 脚本存在性检查（已废弃）

本包不提供 `scripts/`，无需做脚本存在性检查；直接使用“能力对照（无 scripts/）”对应的内置逻辑执行。

<script_fallback>
### 统一执行策略（默认内置逻辑）

```yaml
处理方式: 直接使用内置逻辑执行对应功能
输出: 按 G3 场景内容规则（信息/警告）输出必要的提示与结果

内置能力:
  create_package: 直接创建目录结构和文件
  list_packages: 使用文件查找工具扫描 plan/ 目录
  migrate_package: 直接执行文件移动和索引更新
  validate_package: 直接检查文件存在性和内容完整性
  project_stats: 使用文件查找和统计工具
  upgrade_wiki: 使用文件工具执行扫描、初始化、备份、写入操作（AI负责内容分析和生成）
```
</script_fallback>

<script_execution_report>
### 执行自检报告机制（可选）

**概述:** 当你在执行一组文件/目录操作时，可以用 JSON 结构记录“已完成/待完成/错误信息”，以便中断后可恢复继续。

```json
{
  "operation": "create_package|migrate_package|upgrade_wiki|validate_package|...",
  "success": true,
  "completed": [
    { "step": "步骤描述", "result": "执行结果（如文件路径）", "verify": "AI 质量检查方法" }
  ],
  "failed_at": "失败的步骤（仅 success=false 时）",
  "error_message": "错误信息（仅 success=false 时）",
  "pending": ["待完成任务1", "待完成任务2"],
  "context": { "key": "value" }
}
```

**自检流程:**
1. 读取报告（如有）
2. 质量检查 completed 中已完成的步骤
3. 发现问题则修复
4. 按 pending 列表继续完成剩余任务
</script_execution_report>

<error_recovery>
### 错误恢复机制

**执行失败时:**

<operation_error_handling>
执行错误分类处理:
1. 路径错误: 检查路径、创建目录后重试一次
2. 权限错误: 提示用户处理，暂停流程
3. 格式/数据错误: 标注问题位置，给出修复建议
4. 其他错误: 输出错误详情并停止
</operation_error_handling>

```yaml
输出: 按 G3 场景内容规则输出（可恢复=警告，不可恢复=错误）
```

**文件操作失败时:**

<file_error_handling>
文件操作错误处理:
1. 写入失败: 检查目录、检查冲突、重试一次
2. 读取失败: 检查路径、根据必要性决定处理方式
3. 目录创建失败: 检查父目录和权限
</file_error_handling>

```yaml
写入失败:
  - 检查目标目录是否存在，不存在则创建
  - 检查是否有同名文件冲突
  - 重试一次后仍失败则暂停，输出错误详情

读取失败:
  - 检查文件路径是否正确
  - 文件不存在时根据场景决定:
    - 必需文件: 暂停流程，提示创建
    - 可选文件: 跳过并继续

目录创建失败:
  - 检查父目录是否存在
  - 检查权限问题
  - 提示用户手动创建
```
</error_recovery>
</script_validation>

---

<shell_spec>
## Shell 规范

> 📌 规则引用: Shell 语法规范、工具选择逻辑见 G1，始终生效
</shell_spec>

---

## 规则引用关系

```yaml
被引用:
  - P0 项目配置初始化（helloagents/config.toml）
  - ~validate 命令（方案包/知识库验证）
  - ~init/~upgrade 命令（知识库扫描/初始化/升级）
  - 项目分析阶段（大型项目检测与统计）
  - 方案设计阶段（创建方案包目录与模板）
  - 开发实施阶段（归档迁移与索引更新）

引用:
  - G1 Shell语法规范
  - G3 场景内容规则
  - G4 路由机制
  - references/services/templates.md（文件结构要求）
```
