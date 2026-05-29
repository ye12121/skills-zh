# Issue 追踪器：GitHub

本仓的 Issue 和 PRD 以 GitHub Issue 形式存在。所有操作使用 `gh` CLI。

## 约定

- **创建 Issue**：`gh issue create --title "..." --body "..."`。多行正文用 heredoc。
- **读取 Issue**：`gh issue view <number> --comments`，用 `jq` 过滤评论并同时拉取标签。
- **列出 Issue**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，配合恰当的 `--label` 和 `--state` 过滤。
- **在 Issue 上评论**：`gh issue comment <number> --body "..."`
- **应用/移除标签**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **关闭**：`gh issue close <number> --comment "..."`

从 `git remote -v` 推断仓库——`gh` 在克隆内运行时会自动这么做。

## 当 skill 说"发布到 Issue 追踪器"时

创建一个 GitHub Issue。

## 当 skill 说"拉取相关 ticket"时

运行 `gh issue view <number> --comments`。
