---
name: writing-shape
description: 接收一份原材料 markdown 文件，通过对话式会话把它塑造成文章——起草候选开头、一段一段长出篇幅、在每一步上为格式（列表、表格、callout、引用）讨论。当用户有一堆笔记、片段或粗稿，希望帮忙把它变成可发表的东西时使用。 / Take a markdown file of raw material and shape it into an article through a conversational session — drafting candidate openings, growing the piece paragraph by paragraph, arguing about format (lists, tables, callouts, quotes) at each step. Use when the user has a pile of notes, fragments, or a rough draft and wants help turning it into something publishable.
---

<what-to-do>

用户传递了（或将传递）一份原材料 markdown 文件。把它当作输入堆——可以是一份整齐的片段列表，一墙未结构化散文，或一份转录稿。格式不重要。在做任何其他事之前从头到尾读一遍。

然后跑一段塑形会话，产出一份独立的文章文档。不要编辑原材料文件——对本 skill 而言它是只读的。

如果用户没说文章保存到哪，问一次并记住路径。用户会在会话中编辑文章文件；写入前总是从磁盘重读以保留他们的编辑。

</what-to-do>

<supporting-info>

## 循环

1. **读完原料堆。** 把输入文件完整读完。形成对里面有什么的感觉。
2. **起草 2–3 个候选开头。** 每个开头应当蕴含文章的一种不同论点或角度。把它们全部展示出来。逼用户挑一个或合成一个混合。被选中的开头定义了文章其余部分必须做什么。
3. **一段一段长。** 开头落地后，问"鉴于这个开头，读者下一个需要听到什么？" 从原料堆里拉素材回答。讨论下一节拍是一段散文、一份列表、一张表、一个 callout、一段引用还是一个代码块。每个格式选择都应当是有意的、可辩护的。
4. **边走边追加到文章文件。** 不要批量。每段或每块一旦商定就立刻写下，让用户看到文章成形。
5. **循环步骤 3 直到文章完成。** 用户决定何时完成。

## 对话感

这是反向的盘问环节。在 ideation 中，问题是"你实际注意到了什么？"这里是"这篇文章到底在论证什么？读者需要按什么顺序听？" 推回去。拒绝让弱过渡蒙混过关。如果一段不挣到它的位置，砍掉。

可以反复使用的具体动作：

- "What does this paragraph do for the reader that the previous one didn't?"
- "If I cut this, what breaks?"
- "Is this prose, or should it be a list? Why prose?"
- "This sentence is doing two jobs — split it or pick one."
- "The opening promised X. We've drifted to Y. Either re-thread it or change the opening."

## 从原料堆里挖

把原材料当成采石场，不是脚本。拉一个片段，重塑它以契合周围段落，然后放进去。一个片段可以被拆到多段、与另一个合并或被转述。原料堆的任务是被挖；文章的任务是读起来像一种声音。

如果原料堆缺文章需要的东西，明确点出缺口："We need an example here and the pile doesn't have one — give me one now or we cut this section."

## 值得真争一争的格式问题

为某个节拍选择渲染方式时，把这些权衡和用户大声讨论，而不是静默决定：

- **散文 vs. 列表。** 散文承担论证；列表承担并列项。如果项目并非真正并列，散文更好。如果是，列表更易扫读。
- **行内 vs. callout。** 提示、警告、旁白进 callout（`> [!TIP]`、`> [!NOTE]`）——但只有当它们留在行内会真正打断主论证时。否则保持在行内。
- **表格 vs. 重复结构。** 如果同一形状以相同字段重复 3+ 次，用表格。否则用带粗体引子的散文。
- **引用 vs. 转述。** 原话本身就是重点时引用。只在乎意思时转述。
- **代码块 vs. 行内代码。** 多行、可运行或示意性 → 块。单一 token 或标识符 → 行内。

## 写作节奏

每商定一个块就追加到文章文件。每次写入前从磁盘重读——用户可能在轮次之间编辑过。永不盲目覆盖。如果用户想重写某段，就地编辑那一段；其余别动。

## 范围外

- 挖掘原料堆外的新片段（原料堆就是输入——如果它不全，点出缺口，要么让用户填，要么砍掉那一节）。
- 编辑原材料文件。
- 出版、为某个具体平台格式化或添加用户未要求的 frontmatter。

</supporting-info>
