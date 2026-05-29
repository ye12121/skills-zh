# Issue 追踪器：GitLab

本仓的 Issue 和 PRD 以 GitLab Issue 形式存在。所有操作使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 约定

- **创建 Issue**：`glab issue create --title "..." --description "..."`。多行描述用 heredoc。传 `--description -` 可打开编辑器。
- **读取 Issue**：`glab issue view <number> --comments`。用 `-F json` 获得机器可读输出。
- **列出 Issue**：`glab issue list -F json`，配合恰当的 `--label` 过滤。
- **在 Issue 上评论**：`glab issue note <number> --message "..."`。GitLab 把评论叫做 "notes"。
- **应用/移除标签**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多个标签可用逗号分隔或重复 flag。
- **关闭**：`glab issue close <number>`。`glab issue close` 不接受关闭评论，所以先用 `glab issue note <number> --message "..."` 发解释，再关闭。
- **Merge Request**：GitLab 把 PR 叫做 "merge requests"。用 `glab mr create`、`glab mr view`、`glab mr note` 等——形状与 `gh pr ...` 一致，把 `pr` 换成 `mr`，把 `comment`/`--body` 换成 `note`/`--message`。

从 `git remote -v` 推断仓库——`glab` 在克隆内运行时会自动这么做。

## 当 skill 说"发布到 Issue 追踪器"时

创建一个 GitLab Issue。

## 当 skill 说"拉取相关 ticket"时

运行 `glab issue view <number> --comments`。
