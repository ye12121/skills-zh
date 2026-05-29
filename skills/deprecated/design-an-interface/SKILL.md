---
name: design-an-interface
description: 使用并行子 agent 为某个模块生成多个截然不同的接口设计。当用户希望设计 API、探索接口选项、比较模块形态，或提到 "design it twice" 时使用。 / Generate multiple radically different interface designs for a module using parallel sub-agents. Use when user wants to design an API, explore interface options, compare module shapes, or mentions "design it twice".
---

# 接口设计

灵感来自《A Philosophy of Software Design》中的 "Design It Twice"：你的第一个想法不太可能是最佳方案。先生成多个截然不同的设计，再进行比较。

## 工作流程

### 1. 收集需求

在开始设计之前，理解：

- [ ] 这个模块要解决什么问题？
- [ ] 谁是调用方？（其他模块、外部用户、测试）
- [ ] 关键操作有哪些？
- [ ] 是否存在约束？（性能、兼容性、既有模式）
- [ ] 哪些应该隐藏在内部，哪些应该暴露出来？

询问："这个模块需要做什么？谁会使用它？"

### 2. 生成设计（并行子 agent）

使用 Task 工具同时派出 3 个以上的子 agent。每个都必须产出**截然不同**的方案。

```
Prompt template for each sub-agent:

Design an interface for: [module description]

Requirements: [gathered requirements]

Constraints for this design: [assign a different constraint to each agent]
- Agent 1: "Minimize method count - aim for 1-3 methods max"
- Agent 2: "Maximize flexibility - support many use cases"
- Agent 3: "Optimize for the most common case"
- Agent 4: "Take inspiration from [specific paradigm/library]"

Output format:
1. Interface signature (types/methods)
2. Usage example (how caller uses it)
3. What this design hides internally
4. Trade-offs of this approach
```

### 3. 展示设计

对每个设计展示：

1. **接口签名** —— 类型、方法、参数
2. **使用示例** —— 调用方在实际中如何使用
3. **它隐藏了什么** —— 保留在内部的复杂性

依次展示设计，让用户在比较之前能够吸收每个方案。

### 4. 比较设计

展示完所有设计后，从以下维度进行比较：

- **接口简洁性**：方法更少、参数更简单
- **通用 vs 专用**：灵活性 vs 聚焦
- **实现效率**：这种形态是否允许高效的内部实现？
- **深度**：小接口隐藏巨大复杂性（好） vs 大接口配薄实现（差）
- **易于正确使用** vs **易于误用**

用文字而非表格讨论权衡。突出设计差异最大的地方。

### 5. 综合

往往最好的设计会融合多个方案的洞见。询问：

- "哪个设计最适合你的主要使用场景？"
- "其他设计中是否有值得借鉴的元素？"

## 评估标准

来自《A Philosophy of Software Design》：

**接口简洁性**：方法更少、参数更简单 = 更容易学习并正确使用。

**通用性**：能够在不修改的情况下应对未来的使用场景。但要警惕过度泛化。

**实现效率**：接口形态是否允许高效的实现？还是会强制出别扭的内部结构？

**深度**：小接口隐藏巨大复杂性 = 深模块（好）。大接口配薄实现 = 浅模块（避免）。

## 反模式

- 不要让子 agent 产出相似的设计——强制其产生根本性差异
- 不要跳过比较——价值就在对比之中
- 不要去实现——这纯粹是关于接口形态
- 不要根据实现工作量来评估
