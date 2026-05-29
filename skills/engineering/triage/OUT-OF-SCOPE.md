# Out-of-Scope 知识库

仓库中的 `.out-of-scope/` 目录用来持久化记录被拒绝的功能请求。它有两个目的：

1. **机构记忆** — 一个功能为什么被拒绝，避免 Issue 关闭后理由丢失
2. **去重** — 当一个新 Issue 进来时如果匹配到先前的拒绝，skill 可以浮出之前的决定，而不是重新争论

## 目录结构

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

每个**概念**一个文件，而不是每个 Issue 一个。多个请求同一件事的 Issue 归入同一个文件。

## 文件格式

文件应当用一种轻松、可读的风格写——更像一份简短的设计文档，而不是数据库条目。用段落、代码示例和示例使理由对第一次遇到它的人清晰且有用。

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single color palette defined in
`ThemeConfig`. Supporting multiple themes would require:

- A theme context provider wrapping the entire component tree
- Per-component theme-aware style resolution
- A persistence layer for user theme preferences

This is a significant architectural change that doesn't align with the
project's focus on content authoring. Theming is a concern for downstream
consumers who embed or redistribute the output.

```ts
// The current ThemeConfig interface is not designed for runtime switching:
interface ThemeConfig {
  colors: ColorPalette; // single palette, resolved at build time
  fonts: FontStack;
}
```

## Prior requests

- #42 — "Add dark mode support"
- #87 — "Night theme for accessibility"
- #134 — "Dark theme option"
```

### 文件命名

为概念使用一个简短、描述性的 kebab-case 名称：`dark-mode.md`、`plugin-system.md`、`graphql-api.md`。名称应当足够可辨识，让人浏览目录就能明白什么被拒绝了，不必打开文件。

### 写理由

理由应有实质——不是"我们不想要这个"，而是为什么。好的理由会引用：

- 项目范围或理念（"本项目聚焦于 X；主题化是下游的关注点"）
- 技术约束（"支持这个需要 Y，与我们的 Z 架构冲突"）
- 战略决策（"我们选用 A 而非 B 是因为……"）

理由应当耐用。避免引用临时情况（"我们现在太忙"）——那不是真正的拒绝，而是延期。

## 何时查询 `.out-of-scope/`

分诊期间（第 1 步：收集上下文），读 `.out-of-scope/` 中所有文件。评估新 Issue 时：

- 检查请求是否匹配某个现有的 out-of-scope 概念
- 匹配按概念相似度，而非关键字——"night theme" 匹配 `dark-mode.md`
- 如果匹配上，浮出给维护者："这与 `.out-of-scope/dark-mode.md` 类似——我们之前拒绝这个是因为 [理由]。你现在还这么认为吗？"

维护者可以：

- **确认** — 新 Issue 被追加到现有文件的 "Prior requests" 列表，然后关闭
- **重新考虑** — out-of-scope 文件被删除或更新，Issue 走常规分诊流程
- **不同意** — Issue 相关但不同，继续走常规分诊

## 何时写入 `.out-of-scope/`

只有当 **enhancement**（不是 bug）被以 `wontfix` 拒绝时。流程：

1. 维护者认定一个功能请求超出范围
2. 检查是否已存在匹配的 `.out-of-scope/` 文件
3. 如果有：把新 Issue 追加到 "Prior requests" 列表
4. 如果没有：创建一个新文件，含概念名、决定、理由和首条先前请求
5. 在该 Issue 上张贴评论，解释决定并提到 `.out-of-scope/` 文件
6. 以 `wontfix` 标签关闭 Issue

## 更新或删除 out-of-scope 文件

如果维护者改变主意，对之前拒绝的概念有新看法：

- 删除 `.out-of-scope/` 文件
- skill 不需要重开旧 Issue——它们是历史记录
- 触发重新考虑的新 Issue 走常规分诊流程
