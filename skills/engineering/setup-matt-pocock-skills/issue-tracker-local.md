# Issue 追踪器：本地 Markdown

本仓的 Issue 和 PRD 以 markdown 文件形式存放在 `.scratch/`。

## 约定

- 每个 feature 一个目录：`.scratch/<feature-slug>/`
- PRD 是 `.scratch/<feature-slug>/PRD.md`
- 实现 Issue 是 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号
- 分诊状态记录为每个 Issue 文件顶部附近的 `Status:` 行（角色字符串见 `triage-labels.md`）
- 评论和对话历史追加到文件底部 `## Comments` 标题之下

## 当 skill 说"发布到 Issue 追踪器"时

在 `.scratch/<feature-slug>/` 下创建新文件（如目录不存在则创建）。

## 当 skill 说"拉取相关 ticket"时

读取所引用路径的文件。用户通常会直接传路径或 Issue 编号。
