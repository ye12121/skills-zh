# `setup-matt-pocock-skills` 的 Verify/Check 模式

本项目不会为 `setup-matt-pocock-skills` 添加专门的 verify/check 模式（或独立的 verify skill）。

## 为什么这超出范围

第二个 skill——或一个 `--verify` 标志——用于检查 `docs/agents/*.md` 工件是否仍与种子模板 schema 匹配，会重复现有 setup skill 已经在对话中处理的工作。

预期的工作流是：**运行 `/setup-matt-pocock-skills` 并告诉它验证你当前的设置。** 该 skill 是 prompt 驱动的，因此维护者可以将其限定为一次验证过程（"什么都不要重写，只对照当前种子模板检查我现有的文件并报告漂移"），而无需单独的代码路径。添加一个标志或一个同级 skill 会拆分一个已经可以通过自然语言入口表达的功能的接口面。

将配置管理保持在单个 skill 中，也避免了种子模板演进时两个 skills 互相漂移的维护成本。

## 既往请求

- #106 — Feature request: verify/check mode for setup-matt-pocock-skills
