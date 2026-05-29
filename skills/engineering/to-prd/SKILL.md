---
name: to-prd
description: 将当前对话上下文转化为 PRD 并发布到项目 Issue 追踪器。当用户希望基于当前上下文创建 PRD 时使用。 / Turn the current conversation context into a PRD and publish it to the project issue tracker. Use when user wants to create a PRD from the current context.
---

本 skill 基于当前对话上下文和对代码库的理解，产出一份 PRD（产品需求文档）。**不要**访谈用户 — 只需综合你已经知道的信息即可。

Issue 追踪器和分诊标签词汇表应已提供给你 — 如果没有，请运行 `/setup-matt-pocock-skills`。

## 流程

1. 如果尚未探索过仓库，请先探索仓库以了解代码库的当前状态。在整个 PRD 中使用项目的领域术语表词汇，并尊重你所涉及区域的任何 ADR。

2. 勾勒出为完成实现你需要构建或修改的主要模块。积极寻找机会提取可被独立测试的深模块。

深模块（与浅模块相对）是指通过一个简单的、可测试的、几乎不变的接口封装了大量功能的模块。

与用户确认这些模块是否符合他们的预期。与用户确认他们希望为哪些模块编写测试。

3. 使用下面的模板撰写 PRD，然后发布到项目 Issue 追踪器。应用 `ready-for-agent` 分诊标签 — 无需额外分诊。

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
