# Matt Pocock Skills

由 Claude Code 加载的 agent skills（斜杠命令和行为）的集合。Skills 被组织进多个 bucket，由 `/setup-matt-pocock-skills` 生成的每仓库配置来消费。

## 语言

**Issue 追踪器**：
托管一个仓库 Issue 的工具——GitHub Issues、Linear、本地 `.scratch/` markdown 约定，或类似工具。诸如 `to-issues`、`to-prd`、`triage` 和 `qa` 这样的 skills 会从中读取并写入。
_避免使用_：backlog manager、backlog backend、issue host

**Issue**：
**Issue 追踪器**内单个被追踪的工作单元——一个 bug、任务、PRD 或由 `to-issues` 产出的切片。
_避免使用_：ticket（仅在引用将其称为 ticket 的外部系统时使用）

**分诊角色**：
分诊过程中应用到 **Issue** 上的规范状态机标签（例如 `needs-triage`、`ready-for-afk`）。每个角色通过 `docs/agents/triage-labels.md` 映射到 **Issue 追踪器**中真实的标签字符串。

## 关系

- 一个 **Issue 追踪器**持有许多 **Issue**
- 一个 **Issue** 在同一时间承载一个**分诊角色**

## 标记的歧义

- "backlog" 之前同时被用来表示托管 Issue 的*工具*和其中的*工作集合*——已解决：工具叫做 **Issue 追踪器**；"backlog" 不再作为领域术语使用。
- "backlog backend" / "backlog manager" ——已解决：统一归并为 **Issue 追踪器**。
