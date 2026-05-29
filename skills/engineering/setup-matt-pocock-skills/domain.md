# 领域文档

工程类 skill 在探索代码库时应当如何消费本仓的领域文档。

## 探索前先读这些

- **`CONTEXT.md`** 位于仓库根目录，或
- **`CONTEXT-MAP.md`** 位于仓库根目录（若存在）— 它指向每个上下文的 `CONTEXT.md`。读与当前话题相关的每一个。
- **`docs/adr/`** — 读触及你即将工作的区域的 ADR。在多上下文仓库中，也检查 `src/<context>/docs/adr/` 找上下文范围的决策。

如果这些文件中任何一个不存在，**静默继续**。不要标记其缺失；不要预先建议创建它们。生产者 skill（`/grill-with-docs`）会在术语或决策真正解决时再懒创建它们。

## 文件结构

单上下文仓库（多数仓库）：

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多上下文仓库（根目录存在 `CONTEXT-MAP.md`）：

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context-specific decisions
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## 使用术语表的词汇

当你的输出命名某个领域概念时（Issue 标题、重构提案、假设、测试名），使用 `CONTEXT.md` 中定义的术语。不要漂移到术语表显式避免的同义词。

如果你需要的概念尚未在术语表中，这是一个信号——要么你在发明项目并不使用的语言（重新考虑），要么真有空白（给 `/grill-with-docs` 记一笔）。

## 标记 ADR 冲突

如果你的输出与现有 ADR 矛盾，明确浮出来而不是静默覆盖：

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
