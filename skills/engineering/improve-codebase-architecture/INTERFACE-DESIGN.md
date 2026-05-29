# 接口设计

当用户想为某个被选中的深化候选探索替代接口时，使用这种并行子 agent 模式。基于 "Design It Twice"（Ousterhout）——你的第一个想法不太可能是最好的。

使用 [LANGUAGE.md](LANGUAGE.md) 中的词汇——**module**、**interface**、**seam**、**adapter**、**leverage**。

## 流程

### 1. 框定问题空间

派子 agent 之前，为该候选写一段面向用户的问题空间说明：

- 任何新接口都需要满足的约束
- 它会依赖的依赖项，以及它们属于哪一类（见 [DEEPENING.md](DEEPENING.md)）
- 一段粗略的示意性代码草图，给约束落地——不是提案，只是把约束落到具体形式

把这段展示给用户，然后立即进入第 2 步。用户阅读和思考的同时，子 agent 在并行工作。

### 2. 派遣子 agent

用 Agent 工具并行派遣 3+ 个子 agent。每个必须为该深化模块产出 **大相径庭** 的接口。

给每个子 agent 一份独立的技术 brief（文件路径、耦合细节、来自 [DEEPENING.md](DEEPENING.md) 的依赖类别、seam 背后是什么）。这份 brief 与第 1 步中面向用户的问题空间说明是独立的。给每个 agent 一个不同的设计约束：

- Agent 1: "Minimize the interface — aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility — support many use cases and extension."
- Agent 3: "Optimise for the most common caller — make the default case trivial."
- Agent 4（如适用）: "Design around ports & adapters for cross-seam dependencies."

在 brief 中同时包含 [LANGUAGE.md](LANGUAGE.md) 词汇和 CONTEXT.md 词汇，让每个子 agent 都按架构语言和项目领域语言一致命名事物。

每个子 agent 输出：

1. 接口（类型、方法、参数——以及不变式、顺序、错误模式）
2. 调用方如何使用它的用法示例
3. 实现在 seam 后面隐藏了什么
4. 依赖策略和 adapters（见 [DEEPENING.md](DEEPENING.md)）
5. 取舍——哪里 leverage 高，哪里薄

### 3. 呈现与对比

按顺序呈现各设计，让用户吸收每一个，然后用散文做对比。从 **depth**（接口处的 leverage）、**locality**（变化集中在何处）、**seam 放置位置** 进行比较。

对比后给出你自己的推荐：你认为哪个设计最强，为什么。如果不同设计中的元素可以良好组合，提出一个混合方案。要有主张——用户想要一个明确的判断，不是一份菜单。
