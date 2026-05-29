---
name: writing-fragments
description: 一次盘问环节，从用户那里挖掘片段（fragments）——异质的写作小料（论断、场景、犀利的句子、半成想法）——并把它们追加到单一文档中，作为未来文章的原材料。当用户希望在施加结构之前先发展想法，或提到"fragments"、"ideate"或"raw material"时使用。 / Grilling session that mines the user for fragments — heterogeneous nuggets of writing (claims, vignettes, sharp sentences, half-thoughts) — and appends them to a single document as raw material for a future article. Use when the user wants to develop ideas before imposing structure, or mentions "fragments", "ideate", or "raw material" for writing.
---

<what-to-do>

跑一次产出片段的盘问环节。不留情面地就用户想写的任何主题访谈他们。不要强加阶段、提纲或结构——那明确属于范围外。

随着片段从对话两侧出现，把它们追加到同一份 markdown 文件。用户会在会话中编辑这份文件；写入前总是从磁盘重读以保留他们的编辑。

如果用户没传路径，问一次文档保存到哪，然后在整个会话中记住它。

从用户说的第一件事开始捕获片段，包括初始提示。

第一次写入时，在顶部放一个 H1 的工作标题（可以以后改），其他什么都不放——没有元数据、没有 TOC、没有日期。

</what-to-do>

<supporting-info>

## 什么是片段

片段是任何可能存活到最终文章里的文本。它必须**对作者本人可读**——作者能看出它意思——但不需要定义其术语，也不需要对冷读者可理解。门槛是"这是一段好写作吗？"，而不是"这是一段自包含论证吗？"

片段是故意异质的。可能是片段的东西举例：

- 一句你想在某处用上但还不知道在哪的犀利句子。
- 一个论断，配一行论据。
- 一个场景：发生过的事、一段代码、一个情景、一个类比。
- 一个半成想法："about how X feels like Y，以后想清楚。"
- 一句引用、一段对话、一句偷听到的话。
- 一组凭感觉聚在一起的相关观察。
- 一句抱怨、一句坦白、一句段子收尾。

小说家日记是模型：多年未结构化的"觉察"，日后被挖掘成原材料。片段就是觉察。

## 文件格式

```markdown
# Working title

A first fragment lives here.

It can be multiple paragraphs. It can include lists, code, quotes — whatever
shape the fragment naturally takes.

---

A second fragment.

---

> A quoted line that the user wants to keep around.

A reaction to it.

---

- A cluster of related observations
- That hang together by feel
- And want to be near each other
```

片段之间用水平线（`\n---\n`）分隔。正文内部不出现标题。无标签。除被加入的顺序之外没有别的顺序。

## 写作节奏

静默追加。不要为每个片段征求许可。顺口提一下你加了什么（"加上了"），但不要用保存对话框打断会话。

每次写入前：从磁盘重读文件。用户可能在轮次之间编辑、重排或删除过片段——保留他们的改动。永不覆盖文件；只追加（或者，如用户要求，就地编辑某个具体片段）。

用户可以随时说"砍掉最后一个"、"把那个重写得更犀利"、"把那两个合并"。把它们视为一等指令。

</supporting-info>
