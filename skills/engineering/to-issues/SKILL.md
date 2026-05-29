---
name: to-issues
description: 使用追踪弹纵向切片，将计划、规格说明或 PRD 拆分为 Issue 追踪器上可被独立认领的 Issue。当用户希望把计划转换为 Issue、创建实现工单或将工作拆分为 Issue 时使用。 / Break a plan, spec, or PRD into independently-grabbable issues on the project issue tracker using tracer-bullet vertical slices. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
---

# To Issues

使用纵向切片（追踪弹）将计划拆分为可被独立认领的 Issue。

Issue 追踪器和分诊标签词汇表应已提供给你 — 如果没有，请运行 `/setup-matt-pocock-skills`。

## 流程

### 1. 收集上下文

基于对话上下文中已有的内容工作。如果用户将 Issue 引用（Issue 编号、URL 或路径）作为参数传入，请从 Issue 追踪器中获取它并阅读其完整正文和评论。

### 2. 探索代码库（可选）

如果你尚未探索过代码库，请先这么做以了解代码的当前状态。Issue 标题和描述应使用项目的领域术语表词汇，并尊重你所涉及区域的 ADR。

### 3. 起草纵向切片

将计划拆分为**追踪弹** Issue。每个 Issue 都是一个端到端贯穿所有集成层的薄纵向切片，**而不是**单一层的横向切片。

切片可以是 'HITL' 或 'AFK'。HITL 切片需要人工介入，比如架构决策或设计评审。AFK 切片可以在无人介入的情况下实现并合并。在可能的情况下优先选择 AFK 而非 HITL。

<vertical-slice-rules>
- 每个切片提供一条狭窄但**完整**的路径，贯穿每一层（schema、API、UI、测试）
- 完成的切片本身可演示或可验证
- 优先选择许多薄切片而非少数厚切片
</vertical-slice-rules>

### 4. 向用户求证

将提议的拆分方案以编号列表呈现。对每个切片，展示：

- **标题**：简短描述性名称
- **类型**：HITL / AFK
- **被阻塞于**：哪些其他切片（如果有）必须先完成
- **覆盖的用户故事**：该切片应对哪些用户故事（如果源材料中有的话）

向用户询问：

- 粒度是否合适？（过粗 / 过细）
- 依赖关系是否正确？
- 是否应该合并或进一步拆分某些切片？
- 正确的切片是否被标记为 HITL 和 AFK？

迭代直到用户认可该拆分。

### 5. 将 Issue 发布到 Issue 追踪器

对每个已认可的切片，向 Issue 追踪器发布一个新的 Issue。使用下面的 Issue 正文模板。这些 Issue 被视为已为 AFK agent 准备就绪，因此除非另有指示，请用正确的分诊标签发布它们。

按依赖顺序发布 Issue（阻塞者优先），这样你就可以在 "Blocked by" 字段中引用真实的 Issue 标识符。

<issue-template>
## Parent

A reference to the parent issue on the issue tracker (if the source was an existing issue, otherwise omit this section).

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

Avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it here and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking ticket (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

**不要**关闭或修改任何父 Issue。
