Skills 在 `skills/` 下被组织进 bucket 文件夹：

- `engineering/` — 日常代码工作
- `productivity/` — 日常非代码工作流工具
- `misc/` — 留着但很少使用
- `personal/` — 与我自己的设置绑定，不对外推广
- `in-progress/` — 尚未准备好发布的草稿
- `deprecated/` — 不再使用

`engineering/`、`productivity/` 或 `misc/` 中的每个 skill 都必须在顶层 `README.md` 中有引用，并在 `.claude-plugin/plugin.json` 中有条目。`personal/`、`in-progress/` 和 `deprecated/` 中的 skill 不得出现在二者中的任何一个里。

顶层 `README.md` 中每个 skill 的条目都必须将 skill 名称链接到其 `SKILL.md`。

每个 bucket 文件夹都有一个 `README.md`，其中列出该 bucket 中的每个 skill 及一行描述，且 skill 名称链接到其 `SKILL.md`。
