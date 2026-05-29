---
name: scaffold-exercises
description: 创建包含小节、问题、解答和讲解的练习目录结构，并通过 lint 检查。当用户希望搭建练习脚手架、创建练习占位或新开课程小节时使用。 / Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section.
---

# 搭建练习脚手架

创建可通过 `pnpm ai-hero-cli internal lint` 的练习目录结构，然后使用 `git commit` 提交。

## 目录命名

- **小节（Sections）**：放在 `exercises/` 下，命名为 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **练习（Exercises）**：放在某个小节下，命名为 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 小节编号 = `XX`，练习编号 = `XX.YY`
- 命名采用 dash-case（小写，使用连字符）

## 练习变体

每个练习至少需要以下子文件夹中的一个：

- `problem/` —— 学生工作区，包含 TODO
- `solution/` —— 参考实现
- `explainer/` —— 概念性材料，不含 TODO

搭建占位时，除非计划另有说明，否则默认创建 `explainer/`。

## 必需文件

每个子文件夹（`problem/`、`solution/`、`explainer/`）都需要一个 `readme.md`，要求：

- **不能为空**（必须有真实内容，哪怕只有一行标题）
- 没有失效的链接

搭建占位时，创建一个只包含标题和描述的最小 readme：

```md
# Exercise Title

Description here
```

如果子文件夹中有代码，还需要一个 `main.ts`（> 1 行）。但对于占位来说，只有 readme 的练习也是可以接受的。

## 工作流程

1. **解析计划** —— 提取小节名、练习名和变体类型
2. **创建目录** —— 对每个路径执行 `mkdir -p`
3. **创建占位 readme** —— 每个变体文件夹一个带标题的 `readme.md`
4. **运行 lint** —— `pnpm ai-hero-cli internal lint` 进行校验
5. **修复所有错误** —— 迭代直至 lint 通过

## Lint 规则汇总

linter（`pnpm ai-hero-cli internal lint`）会检查：

- 每个练习都有子文件夹（`problem/`、`solution/`、`explainer/`）
- `problem/`、`explainer/` 或 `explainer.1/` 中至少存在一个
- 主子文件夹中存在非空的 `readme.md`
- 不存在 `.gitkeep` 文件
- 不存在 `speaker-notes.md` 文件
- readme 中没有失效的链接
- readme 中没有 `pnpm run exercise` 命令
- 除非是仅含 readme 的子文件夹，否则每个子文件夹都需要 `main.ts`

## 移动/重命名练习

在重新编号或移动练习时：

1. 使用 `git mv`（而非 `mv`）重命名目录，以保留 git 历史
2. 更新数字前缀以保持顺序
3. 移动后重新运行 lint

示例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 示例：从计划搭建脚手架

给定如下计划：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

创建：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然后创建 readme 占位：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
