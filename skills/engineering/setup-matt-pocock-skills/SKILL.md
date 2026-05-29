---
name: setup-matt-pocock-skills
description: 在 AGENTS.md/CLAUDE.md 中设置一个 `## Agent skills` 块，并填充 `docs/agents/`，让工程类 skill 知道本仓库的 Issue 追踪器（GitHub 或本地 markdown）、分诊标签词汇和领域文档布局。在首次使用 `to-issues`、`to-prd`、`triage`、`diagnose`、`tdd`、`improve-codebase-architecture` 或 `zoom-out` 之前运行；或者当这些 skill 看起来缺失关于 Issue 追踪器、分诊标签或领域文档的上下文时运行。 / Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's issue tracker (GitHub or local markdown), triage label vocabulary, and domain doc layout. Run before first use of `to-issues`, `to-prd`, `triage`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out` — or if those skills appear to be missing context about the issue tracker, triage labels, or domain docs.
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

为工程类 skill 假设的、每仓一份的配置打好脚手架：

- **Issue 追踪器** — Issue 存在哪里（默认 GitHub；本地 markdown 也开箱即用）
- **分诊标签** — 五个规范分诊角色使用的字符串
- **领域文档** — `CONTEXT.md` 和 ADR 的所在地，以及读取它们的消费规则

这是一个由提示驱动的 skill，不是确定性脚本。探索、呈现你发现的内容、与用户确认，然后写入。

## 流程

### 1. 探索

查看当前仓库以了解起始状态。读已存在的东西；不要假设：

- `git remote -v` 和 `.git/config` — 这是 GitHub 仓库吗？是哪个？
- 仓库根目录的 `AGENTS.md` 和 `CLAUDE.md` — 哪一个存在？是否已经有 `## Agent skills` 节？
- 根目录的 `CONTEXT.md` 和 `CONTEXT-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目录
- `docs/agents/` — 这个 skill 之前的输出是否已存在？
- `.scratch/` — 已经在使用本地-markdown Issue 追踪约定的迹象

### 2. 呈现发现并询问

总结存在什么、缺失什么。然后**一次一项**带用户走过三个决定——呈现一节、得到用户回答、再下一节。不要一次倾倒三个。

假设用户不知道这些术语意味着什么。每一节都以简短解释开头（它是什么、为什么这些 skill 需要它、不同选择会带来什么变化）。然后展示各选项与默认值。

**Section A — Issue 追踪器。**

> 解释：本仓的 "Issue 追踪器"是 Issue 所在的地方。`to-issues`、`triage`、`to-prd`、`qa` 等 skill 会读写它——它们需要知道是该调用 `gh issue create`、在 `.scratch/` 下写一个 markdown 文件，还是遵循你描述的其他工作流。挑选你实际为这个仓库追踪工作的地方。

默认姿态：这些 skill 是为 GitHub 设计的。如果 `git remote` 指向 GitHub，建议它。如果 `git remote` 指向 GitLab（`gitlab.com` 或自托管）, 建议 GitLab。否则（或用户偏好其他）提供：

- **GitHub** — Issue 存在仓库的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab** — Issue 存在仓库的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **Local markdown** — Issue 以文件形式存放在本仓 `.scratch/<feature>/` 下（适合个人项目或没有远端的仓库）
- **Other**（Jira、Linear 等）— 请用户用一段话描述工作流；skill 会以自由文本记录下来

**Section B — 分诊标签词汇。**

> 解释：当 `triage` skill 处理一个进来的 Issue 时，它通过状态机推动它——需要评估、等待提报者、AFK agent 可拾、需要人类、不会修。要做到这一点，它需要应用与你**实际配置好**的字符串匹配的标签（或你的 Issue 追踪器中的等价物）。如果你的仓库已经使用不同的标签名（例如 `bug:triage` 而不是 `needs-triage`），在这里映射过去，让 skill 应用正确的标签而不是创建重复项。

五个规范角色：

- `needs-triage` — 维护者需要评估
- `needs-info` — 等待提报者
- `ready-for-agent` — 完全规格化，可 AFK（agent 无需人类上下文即可拾起）
- `ready-for-human` — 需要人类实现
- `wontfix` — 不会处理

默认：每个角色的字符串等于其名称。问用户是否想覆盖任何。如果他们的 Issue 追踪器没有现有标签，默认值即可。

**Section C — 领域文档。**

> 解释：某些 skill（`improve-codebase-architecture`、`diagnose`、`tdd`）读取一个 `CONTEXT.md` 文件以了解项目的领域语言，以及 `docs/adr/` 中的过往架构决策。它们需要知道仓库是一个全局上下文还是多个（例如 monorepo 中有独立的前端/后端上下文）以便去对的地方查找。

确认布局：

- **Single-context** — 仓库根目录一个 `CONTEXT.md` + `docs/adr/`。多数仓库属于此。
- **Multi-context** — 根目录的 `CONTEXT-MAP.md` 指向每个上下文的 `CONTEXT.md`（通常是 monorepo）。

### 3. 确认并编辑

向用户展示草稿：

- 要添加到 `CLAUDE.md` / `AGENTS.md` 中正在编辑那一份的 `## Agent skills` 块（选择规则见第 4 步）
- `docs/agents/issue-tracker.md`、`docs/agents/triage-labels.md`、`docs/agents/domain.md` 的内容

让他们在写入前编辑。

### 4. 写入

**选要编辑的文件：**

- 如果 `CLAUDE.md` 存在，编辑它。
- 否则如果 `AGENTS.md` 存在，编辑它。
- 如果两个都不存在，问用户要创建哪一个——不要替他们决定。

如果 `CLAUDE.md` 已存在，永不创建 `AGENTS.md`（反之亦然）——始终编辑已存在的那个。

如果选中的文件中已经存在 `## Agent skills` 块，就地更新其内容，而不是追加重复。不要覆盖用户对周围分节的编辑。

块的样子：

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

然后用本 skill 文件夹中的种子模板作为起点写三个文档文件：

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub Issue 追踪器
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab Issue 追踪器
- [issue-tracker-local.md](./issue-tracker-local.md) — 本地-markdown Issue 追踪器
- [triage-labels.md](./triage-labels.md) — 标签映射
- [domain.md](./domain.md) — 领域文档消费规则 + 布局

对于"其他" Issue 追踪器，使用用户的描述从零写 `docs/agents/issue-tracker.md`。

### 5. 完成

告诉用户设置完成，以及现在哪些工程类 skill 会从这些文件读取。提到他们以后可以直接编辑 `docs/agents/*.md`——除非他们想切换 Issue 追踪器或从零重启，否则没必要重跑这个 skill。
