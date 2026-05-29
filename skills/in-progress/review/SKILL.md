---
name: review
description: 沿两个轴评审自固定点（提交、分支、tag 或 merge-base）以来的变更——Standards（代码是否遵循本仓的文档化编码标准？）和 Spec（代码是否匹配源 Issue/PRD 要求？）。两次评审在并行子 agent 中进行，并排报告。当用户希望评审一个分支、一个 PR、在制变更，或要求"review since X"时使用。 / Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/PRD asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
---

# Review

沿两个轴对 `HEAD` 与用户给定固定点之间的差异进行评审：

- **Standards** — 代码是否符合本仓文档化的编码标准？
- **Spec** — 代码是否忠实实现了源 Issue / PRD / 规格？

两个轴都作为**并行子 agent**运行，避免互相污染上下文，然后本 skill 汇总它们的发现。

Issue 追踪器应当已经提供给你——如果 `docs/agents/issue-tracker.md` 缺失则运行 `/setup-matt-pocock-skills`。

## 流程

### 1. 钉住固定点

无论用户说什么都是固定点——一个提交 SHA、分支名、tag、`main`、`HEAD~5` 等。不要多事；直接传过去。如果他们没指定，问："Review against what — a branch, a commit, or `main`?" 没有这个就别继续。

把 diff 命令捕获一次：`git diff <fixed-point>...HEAD`（三点，使比较针对 merge-base）。同时通过 `git log <fixed-point>..HEAD --oneline` 记下提交列表。

### 2. 识别规格来源

按以下顺序找源规格：

1. 提交信息中的 Issue 引用（`#123`、`Closes #45`、GitLab `!67` 等）——通过 `docs/agents/issue-tracker.md` 中的工作流拉取。
2. 用户作为参数传入的路径。
3. `docs/`、`specs/` 或 `.scratch/` 下与分支名或功能匹配的 PRD/规格文件。
4. 如果什么都找不到，问用户规格在哪。如果他们说没有，**Spec** 子 agent 跳过并报告 "no spec available"。

### 3. 识别标准来源

仓库里任何记录代码应当如何编写的东西。常见位置：

- `CLAUDE.md`、`AGENTS.md`
- `CONTRIBUTING.md`
- `CONTEXT.md`、`CONTEXT-MAP.md`、各上下文的 `CONTEXT.md`
- `docs/adr/`（架构决策即标准）
- `.editorconfig`、`eslint.config.*`、`biome.json`、`prettier.config.*`、`tsconfig.json`（机器强制的标准——记下来但不要重检工具已经在检的内容）
- 仓库根目录或 `docs/` 下任何 `STYLE.md`、`STANDARDS.md`、`STYLEGUIDE.md` 之类的

收集文件列表。**Standards** 子 agent 会读它们。

### 4. 并行派出两个子 agent

发一条消息，里面两次 `Agent` 工具调用。两个都用 `general-purpose` 子 agent。

**Standards 子 agent 提示**——包含：

- 完整的 diff 命令和提交列表。
- 你在第 3 步找到的标准来源文件列表。
- Brief："Read the standards docs. Then read the diff. Report — per file/hunk where relevant — every place the diff violates a documented standard. Cite the standard (file + the rule). Distinguish hard violations from judgement calls. Skip anything tooling enforces. Under 400 words."

**Spec 子 agent 提示**——包含：

- diff 命令和提交列表。
- 规格的路径或拉取下来的内容。
- Brief："Read the spec. Then read the diff. Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

如果规格缺失，跳过 Spec 子 agent 并在最终报告中说明。

### 5. 汇总

在 `## Standards` 和 `## Spec` 标题下呈现两份报告，原样或轻度清理。**不要**合并或重新排序发现——两个轴刻意分开，让用户能独立看见。

以一行摘要结尾：每轴发现总数，以及最严重的单一问题（如有）。

## 为什么两个轴

一次变更可能一个轴通过另一个轴失败：

- 遵循所有标准但实现了错误的东西 → **Standards 通过，Spec 失败。**
- 完全按 Issue 要求做但破坏了项目惯例 → **Spec 通过，Standards 失败。**

分开报告防止一个轴掩盖另一个。
