---
name: tdd
description: 测试驱动开发，使用红-绿-重构循环。当用户希望使用 TDD 构建功能或修复 bug、提到「红-绿-重构」、需要集成测试，或要求测试先行的开发方式时使用。 / Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# 测试驱动开发

## 理念

**核心原则**：测试应该通过公共接口验证行为，而不是验证实现细节。代码可以完全改变，但测试不应改变。

**好的测试**是集成式的：它们通过公共 API 走真实的代码路径。它们描述系统**做什么**，而不是**怎么做**。一个好的测试读起来像规格说明——"用户可以用有效购物车结账"告诉你确切存在的能力。这些测试在重构时不会被打破，因为它们不关心内部结构。

**坏的测试**与实现耦合。它们 mock 内部协作者，测试私有方法，或者通过外部手段验证（比如直接查询数据库而不是通过接口）。警告信号：你重构后测试失败，但行为没变。如果你重命名一个内部函数后测试失败，那些测试在测实现，不是测行为。

参见 [tests.md](tests.md) 获取示例，以及 [mocking.md](mocking.md) 了解 mock 指南。

## 反模式：水平切片

**不要先写所有测试，再写所有实现。** 这就是"水平切片"——把 RED 理解为"写所有测试"，把 GREEN 理解为"写所有代码"。

这会产生**糟糕的测试**：

- 批量写的测试测的是**想象**的行为，而不是**实际**的行为
- 你会去测试**形状**（数据结构、函数签名），而不是面向用户的行为
- 测试变得对真实变化不敏感——行为坏了它通过，行为没事它失败
- 你跑在了视野之外，在理解实现之前就提前承诺了测试结构

**正确做法**：通过曳光弹做纵向切片。一个测试 → 一个实现 → 重复。每个测试都对上一轮所学做出回应。因为你刚写完代码，所以你确切知道哪些行为重要、怎么验证。

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## 工作流

### 1. 计划

探索代码库时，使用项目的领域术语表，使测试名称和接口词汇与项目语言一致，并尊重所触及区域的 ADR。

写代码之前：

- [ ] 与用户确认需要哪些接口变更
- [ ] 与用户确认要测试哪些行为（排定优先级）
- [ ] 识别 [深模块](deep-modules.md) 的机会（小接口、深实现）
- [ ] 为 [可测试性](interface-design.md) 设计接口
- [ ] 列出要测试的行为（不是实现步骤）
- [ ] 让用户审批计划

问："公共接口应该长什么样？哪些行为最重要要测？"

**你不可能测所有东西。** 与用户确认到底哪些行为最关键。把测试精力集中在关键路径和复杂逻辑上，而不是每一个可能的边界情况。

### 2. 曳光弹

写一个测试，确认系统的一件事：

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

这是你的曳光弹——证明端到端的路径可走通。

### 3. 增量循环

对剩下的每个行为：

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

规则：

- 一次一个测试
- 只写刚好够通过当前测试的代码
- 不要预测未来的测试
- 测试聚焦在可观察行为上

### 4. 重构

所有测试通过后，寻找 [重构候选](refactoring.md)：

- [ ] 提取重复
- [ ] 深化模块（把复杂度藏到简单接口背后）
- [ ] 在自然处应用 SOLID 原则
- [ ] 思考新代码对既有代码揭示了什么
- [ ] 每一步重构后跑测试

**红的时候不要重构。** 先回到绿。

## 每轮检查表

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
