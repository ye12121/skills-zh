---
name: grill-with-docs
description: 盘问环节，将你的方案与既有领域模型对照、磨砺术语，并在决策成形时同步更新文档（CONTEXT.md、ADR）。当用户希望用项目自身的语言和已记录的决策来压力测试某个方案时使用。 / Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

围绕这个方案的每个方面对我进行不留情面的追问，直到我们达成共识。沿着设计树的每个分支一一走下去，逐一厘清各决策之间的依赖关系。对于每个问题，提供你建议的答案。

一次只问一个问题，等到对该问题得到反馈后再继续。

如果某个问题可以通过探索代码库得到答案，那就去探索代码库。

</what-to-do>

<supporting-info>

## 领域感知

在探索代码库时，也要留意现有文档：

### 文件结构

大多数 repo 只有单一上下文：

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

如果根目录存在 `CONTEXT-MAP.md`，则该 repo 具有多个上下文。该 map 指明各上下文的位置：

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← 系统级决策
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← 上下文专属决策
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

按需创建文件——只在确实有内容要写时才建。如果不存在 `CONTEXT.md`，那就在第一个术语被厘清时创建它。如果不存在 `docs/adr/`，那就在第一份 ADR 需要落地时创建它。

## 盘问环节中

### 对照术语表进行挑战

当用户使用的术语与 `CONTEXT.md` 中既有的语言冲突时，立刻指出。"你的术语表把 'cancellation' 定义为 X，但你似乎说的是 Y——到底是哪个？"

### 磨砺模糊语言

当用户使用含糊或被滥用的术语时，提出一个精确的规范术语。"你说的是 'account'——指的是 Customer 还是 User？两者不是一回事。"

### 讨论具体场景

在讨论领域关系时，用具体场景对其进行压力测试。编造一些场景去探测边界情况，迫使用户对相关概念之间的边界给出精确表述。

### 与代码交叉对照

当用户陈述某事如何运作时，检查代码是否一致。如果发现矛盾，把它摆出来："你的代码取消的是整个 Order，但你刚才说可以部分取消——哪个才对？"

### 同步更新 CONTEXT.md

一旦某个术语得到厘清，就立刻更新 `CONTEXT.md`。不要积攒——发生即记录。使用 [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) 中的格式。

`CONTEXT.md` 中应完全不含实现细节。不要把 `CONTEXT.md` 当作规格说明、草稿纸或实现决策的仓库。它只是术语表，仅此而已。

### 节制地提议 ADR

只有当下面三点同时成立时，才提议创建 ADR：

1. **难以撤回**——以后改变主意的代价不容忽视
2. **缺乏上下文时令人意外**——未来的读者会想"他们为什么这么做？"
3. **来自真实的权衡**——确实存在多个备选方案，并因特定理由选择了其中之一

只要缺少其中任一条，就跳过 ADR。使用 [ADR-FORMAT.md](./ADR-FORMAT.md) 中的格式。

</supporting-info>
