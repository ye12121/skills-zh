---
name: qa
description: 互动式 QA 会话，用户以对话方式报告 bug 或问题，由 agent 创建 GitHub issue。在后台探索代码库以获取上下文和领域语言。当用户希望报告 bug、做 QA、以对话方式提 issue，或提到 "QA session" 时使用。 / Interactive QA session where user reports bugs or issues conversationally, and the agent files GitHub issues. Explores the codebase in the background for context and domain language. Use when user wants to report bugs, do QA, file issues conversationally, or mentions "QA session".
---

# QA 会话

进行一场互动式 QA 会话。用户描述他们遇到的问题。你进行澄清，在代码库中探索获取上下文，并创建持久、面向用户、使用项目领域语言的 GitHub issue。

## 对于用户提出的每个问题

### 1. 倾听并做轻量澄清

让用户用自己的语言描述问题。**最多提 2-3 个简短的澄清性问题**，聚焦于：

- 期望发生什么 vs 实际发生了什么
- 复现步骤（如不显而易见）
- 是稳定复现还是偶发

不要过度盘问。如果描述已经足以创建 issue，就继续往下走。

### 2. 在后台探索代码库

在与用户对话的同时，在后台启动一个 Agent（subagent_type=Explore）来了解相关区域。目标**不是**找出修复方案——而是：

- 学习该区域使用的领域语言（查看 UBIQUITOUS_LANGUAGE.md）
- 理解该特性应该做什么
- 识别用户可见行为的边界

这些上下文帮助你写出更好的 issue——但 issue 本身**不应**引用特定文件、行号或内部实现细节。

### 3. 评估范围：单个 issue 还是拆分？

在创建之前，决定这是一个**单个 issue** 还是需要**拆分为多个 issue**。

何时拆分：

- 修复跨越多个独立区域（例如"表单校验有问题，并且成功提示缺失，并且重定向坏了"）
- 存在明显可分割的关注点，不同的人可以并行处理
- 用户描述的内容具有多个不同的失败模式或症状

何时保持单个 issue：

- 这是同一处的一种错误行为
- 所有症状都由同一个根本行为引起

### 4. 创建 GitHub issue

使用 `gh issue create` 创建 issue。**不要**先让用户审核——直接创建并分享 URL。

issue 必须是**持久的**——即使经过大型重构后仍应有意义。从用户视角来写。

#### 单个 issue 模板

```
## What happened

[Describe the actual behavior the user experienced, in plain language]

## What I expected

[Describe the expected behavior]

## Steps to reproduce

1. [Concrete, numbered steps a developer can follow]
2. [Use domain terms from the codebase, not internal module names]
3. [Include relevant inputs, flags, or configuration]

## Additional context

[Any extra observations from the user or from codebase exploration that help frame the issue — e.g. "this only happens when using the Docker layer, not the filesystem layer" — use domain language but don't cite files]
```

#### 拆分（多个 issue）

按依赖顺序创建 issue（先创建阻塞项），以便能引用真实的 issue 编号。

每个子 issue 使用以下模板：

```
## Parent issue

#<parent-issue-number> (if you created a tracking issue) or "Reported during QA session"

## What's wrong

[Describe this specific behavior problem — just this slice, not the whole report]

## What I expected

[Expected behavior for this specific slice]

## Steps to reproduce

1. [Steps specific to THIS issue]

## Blocked by

- #<issue-number> (if this issue can't be fixed until another is resolved)

Or "None — can start immediately" if no blockers.

## Additional context

[Any extra observations relevant to this slice]
```

在做拆分时：

- **多个薄 issue 优于少数厚 issue** —— 每个都应可独立修复和验证
- **如实标注阻塞关系** —— 如果 issue B 在 issue A 解决前确实无法测试，就这么写。如果它们相互独立，则将两者都标记为 "None — can start immediately"
- **按依赖顺序创建 issue**，以便在 "Blocked by" 中引用真实的 issue 编号
- **最大化并行度** —— 目标是让多个人（或 agent）能够同时认领不同的 issue

#### 所有 issue 正文的通用规则

- **不要写文件路径或行号** —— 这些会过时
- **使用项目的领域语言**（若存在 UBIQUITOUS_LANGUAGE.md，请查阅）
- **描述行为，而非代码** —— "the sync service fails to apply the patch" 而不是 "applyPatch() throws on line 42"
- **复现步骤是必需的** —— 如果你无法确定，问用户
- **保持简洁** —— 开发者应能在 30 秒内读完这个 issue

创建完成后，打印所有 issue 的 URL（并汇总阻塞关系），然后询问："下一个 issue，还是我们结束了？"

### 5. 继续会话

持续进行直到用户说完成。每个 issue 都是独立的——不要把它们打包处理。
