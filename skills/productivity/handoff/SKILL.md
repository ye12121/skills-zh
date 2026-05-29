---
name: handoff
description: 将当前对话压缩为交接文档，供另一个 agent 接手继续工作。 / Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "下一个会话将用于什么？"
---

撰写一份交接文档，总结当前对话，以便新的 agent 可以继续工作。保存到用户操作系统的临时目录 —— 而非当前工作区。

在文档中包含一个"建议 skills"章节，列出 agent 应当调用的 skills。

不要重复其他制品（PRD、计划、ADR、issues、commits、diffs）中已有的内容。改为通过路径或 URL 引用。

对任何敏感信息进行脱敏处理，例如 API 密钥、密码或个人身份信息。

如果用户传入了参数，将其视为对下一个会话关注重点的描述，并据此调整文档内容。
