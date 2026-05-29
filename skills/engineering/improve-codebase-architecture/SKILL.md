---
name: improve-codebase-architecture
description: 在 CONTEXT.md 中的领域语言以及 docs/adr/ 中的决策指导下，在代码库中寻找深化（deepening）机会。当用户希望改进架构、寻找重构机会、合并紧耦合的模块，或让代码库更易于测试、更便于 AI 浏览时使用。 / Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
---

# Improve Codebase Architecture

揭示架构上的摩擦，并提出 **深化机会（deepening opportunities）** —— 把浅模块改造为深模块的重构。目标是可测试性以及对 AI 友好的可浏览性。

## 术语表

请在每条建议中严格使用这些术语。语言的一致性正是关键 —— 不要漂移到 "component"、"service"、"API" 或 "boundary"。完整定义见 [LANGUAGE.md](LANGUAGE.md)。

- **Module（模块）** —— 任何具有接口和实现的东西（函数、类、包、切片）。
- **Interface（接口）** —— 调用方为使用该模块所必须了解的一切：类型、不变量、错误模式、调用顺序、配置。不只是类型签名。
- **Implementation（实现）** —— 内部代码。
- **Depth（深度）** —— 接口处的杠杆作用：用很小的接口承载大量行为。**Deep（深）** = 高杠杆。**Shallow（浅）** = 接口几乎与实现一样复杂。
- **Seam（缝）** —— 接口所在的位置；可以在不修改原地代码的情况下改变行为的地方。（请使用此词，不要用 "boundary"。）
- **Adapter（适配器）** —— 在某个 seam 处满足某个接口的具体实现。
- **Leverage（杠杆）** —— 调用方从深度中获得的收益。
- **Locality（局部性）** —— 维护者从深度中获得的收益：变更、缺陷、知识集中在一个地方。

关键原则（完整列表见 [LANGUAGE.md](LANGUAGE.md)）：

- **删除测试（Deletion test）**：设想删除该模块。如果复杂度随之消失，那它只是一个透传层。如果复杂度在 N 个调用方处再次出现，则说明它确有其价值。
- **接口就是测试面（The interface is the test surface）。**
- **一个 adapter = 假想的 seam。两个 adapter = 真实的 seam。**

本 skill 由项目的领域模型 _驱动_。领域语言为良好的 seam 命名；ADR 记录了本 skill 不应再次推翻的决策。

## 流程

### 1. 探索

先阅读项目的领域术语表以及所涉及区域的任何 ADR。

然后使用 Agent 工具（`subagent_type=Explore`）来遍历代码库。不要墨守僵硬的启发式规则 —— 有机地探索，并记录你感到摩擦之处：

- 哪些地方需要在许多小模块间来回跳转才能理解一个概念？
- 哪些模块是 **shallow** 的 —— 接口几乎与实现一样复杂？
- 哪些纯函数只是为了可测试性而被抽出，但真正的缺陷却隐藏在它们的调用方式中（缺乏 **locality**）？
- 哪些紧耦合的模块在 seam 之间发生泄漏？
- 代码库中哪些部分没有测试，或难以通过当前接口进行测试？

对任何你怀疑是 shallow 的部分应用 **deletion test**：删除它会让复杂度集中起来，还是只是把它挪个位置？"是的，会集中" 才是你想要的信号。

### 2. 用 HTML 报告呈现候选项

向操作系统临时目录写入一个自包含的 HTML 文件，这样不会污染仓库。先从 `$TMPDIR` 解析临时目录，找不到则回退到 `/tmp`（Windows 上为 `%TEMP%`），写入 `<tmpdir>/architecture-review-<timestamp>.html`，使每次运行都得到一个新文件。为用户打开它 —— Linux 上 `xdg-open <path>`，macOS 上 `open <path>`，Windows 上 `start <path>` —— 并告诉他们绝对路径。

报告使用 **通过 CDN 引入的 Tailwind** 完成布局与样式，使用 **通过 CDN 引入的 Mermaid** 绘制那些用图/流程图/时序图能可靠传达结构的场景。把 Mermaid 与手工 CSS/SVG 视觉混合使用 —— 当关系是图形形态时（调用图、依赖图、时序图）用 Mermaid，而当你想做更具编辑感的视觉（质量示意图、横截面图、坍缩动画）时用手工搭建的 div/SVG。每个候选项都要有一个 **前后对比的可视化**。要有视觉冲击。

每个候选项使用与之前相同的模板，但渲染为卡片：

- **Files** —— 涉及哪些文件/模块
- **Problem** —— 当前架构为何会带来摩擦
- **Solution** —— 用通俗语言描述将要改变什么
- **Benefits** —— 从 locality 与 leverage 的角度说明，以及测试将如何得到改善
- **Before / After 图示** —— 并排展示，自绘，展示浅薄之处与深化效果
- **Recommendation strength（推荐强度）** —— `Strong`、`Worth exploring`、`Speculative` 之一，渲染为徽章

报告以 **Top recommendation（最佳推荐）** 部分作为结尾：你建议首先处理哪个候选项，以及为什么。

**使用 CONTEXT.md 的词汇表达领域概念，使用 [LANGUAGE.md](LANGUAGE.md) 的词汇表达架构概念。** 如果 `CONTEXT.md` 中定义了 "Order"，那就讲 "the Order intake module" —— 而不是 "the FooBarHandler"，也不是 "the Order service"。

**ADR 冲突**：如果一个候选项与现有 ADR 相矛盾，只有当摩擦真的严重到值得重新审视该 ADR 时才提出。在卡片中清晰标记（例如一个警告框：_"contradicts ADR-0007 — but worth reopening because…"_）。不要把 ADR 所禁止的每个理论上的重构都列出来。

完整的 HTML 骨架、图示模式与样式指引见 [HTML-REPORT.md](HTML-REPORT.md)。

此时还 **不要** 提议接口。文件写完后，问用户："你想探索其中的哪一个？"

### 3. 盘问环节

一旦用户选定了候选项，就进入盘问环节的对话。与他们一起遍历设计树 —— 约束、依赖、深化后模块的形态、seam 后面是什么、哪些测试会留下。

随着决策成型，副作用会在过程中即时发生：

- **如果要把深化后的模块命名为 `CONTEXT.md` 中没有的概念？** 把该术语加入 `CONTEXT.md` —— 与 `/grill-with-docs` 相同的纪律（参见 [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md)）。如果文件不存在，则按需懒创建。
- **在对话中精确化某个模糊术语？** 当场更新 `CONTEXT.md`。
- **用户以某个承重的理由拒绝该候选项？** 提议写一份 ADR，措辞如：_"要不要我把这个记录为一条 ADR，这样未来的架构评审就不会再提议它了？"_ 只有当那个理由是未来探索者为了避免重复提议同一件事所确实需要的，才提议；对临时性理由（"现在不值得"）和不言自明的理由则跳过。参见 [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md)。
- **想为深化后的模块探索多种备选接口？** 参见 [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md)。
