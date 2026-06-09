---
name: align-before-coding
description: 写代码前先和用户对齐再实现，杜绝 agent 自由发挥跑偏。流程：先读累积的「对齐日志」取经验、接续未完成项 → 读真实代码 → 产出可确认的对齐卡（目标/验收/范围内外/思路/落点/待澄清）→ 用户明确放行前不写任何代码 → 结束把状态（未实现/部分实现/已完成）与遗留写回日志以便续作。提问都给带推荐项的选项。当用户提新需求、要加功能、改某段逻辑，或说「对齐一下/先别写/接着上次/按我的思路改」时使用。 / Before coding, align with the user then implement so the agent can't freelance and drift. Flow: read the cumulative "alignment journal" for lessons and unfinished items → read the real code → produce a confirmable alignment card (goal/acceptance/in-scope/out-of-scope/approach/change sites/open questions) → no code until the user explicitly approves → write status (not done/partial/done) and leftovers back to the journal so work resumes. Offer options when asking. Use when the user raises a requirement, adds a feature, changes logic, or says "align / don't code yet / continue last time / follow my approach".
---

# 动手前先对齐

需求一落地，agent 最容易犯的错是**按自己的理解就开干**。本 skill 加一道闸门：**先对齐，后写码**，并把每次的对齐与进展记进一份**累积日志**，下次先读它——既复用历史经验，又能接着没做完的活继续。

- **目标 = 目的地**（要做什么、为什么）——必须对齐。
- **实现思路 = 方向**（怎么改、改哪里）——用户给了就照办，没给就由 agent 提议。

闭环：**读日志 → 对齐卡 → 硬门 → 实现 → 回执 → 更新日志**。

## 贯穿原则：提问必带选项

⚠️ 对齐过程里**每次向用户提问，都给 2–4 个具体选项 / 建议，并标出推荐项**，让用户能直接选；用户也可自己输入想法。别甩一个开放式问题让人从零想——选项能让简单问题被秒答，例子还能帮用户厘清思路。适用于：接续还是新需求、实现思路选型、范围取舍、每个待澄清点。每个选项配一句「这么选的后果 / 取舍」。

## 第一步：先读对齐日志

唯一的累积记忆文件：**`docs/alignments/JOURNAL.md`**（不存在则创建，模板见末尾）。**每次调用本 skill，先读它**，然后：

- 看「进行中 / 有遗留」——若有未完成项，主动问用户：**接着做 `<slug>`（从它的遗留处续），还是新需求？**
- 看「经验 / 教训」——把过往踩过的坑、定过的约定用到本次。

## 第二步：分级（别让流程过重）

估改动规模，按级走，避免每次套全套而被嫌弃：

- **小改动**（改文案、单行逻辑、明显的局部修补）→ 轻量：一两句复述「我理解你要 X、改 Y 处，对吗？」确认即可；仍要在日志留一行状态。
- **大改动**（新功能、跨模块、改公共逻辑/接口、拿不准）→ 走完整流程。

## 第三步：先读码，再产出对齐卡

⚠️ **先翻真实代码再写对齐卡。** 不要凭空想——读完相关文件，才能把「落点」钉到现实，常能暴露「以为改这、其实在那」。

对齐卡就是日志里该需求的**一节**（字段见末尾模板）。默认直接写进 `JOURNAL.md`；若需求大、细节多，可把完整卡另存 `docs/alignments/<YYYY-MM-DD>-<slug>.md` 并从日志节链接。若仓库已配 issue 追踪器（见 [`setup-matt-pocock-skills`](../setup-matt-pocock-skills/SKILL.md)），可顺带开/引一个 issue（衔接 [`to-prd`](../to-prd/SKILL.md) / [`to-issues`](../to-issues/SKILL.md)）。

**实现思路两种模式**：
1. **用户给了思路** → 照办，不得中途自行改方向；读码后发现行不通 → **停下回报、更新对齐卡、重新对齐**，而不是默默改。
2. **用户没给思路** → agent 提议 2–3 套候选方案（标出推荐项 + 各自取舍），让用户直接选或改，等拍板再继续。

## 第四步：硬确认门

⚠️ 贴出对齐卡 + **明确请求放行**，然后**停下**。在用户明确说「开始 / 可以了 / 放行」之前，**一行代码都不写**。用户修改或补充 → 更新对齐卡 → 再次请求放行。

## 第五步：实现（克制）

放行后才动手，且全程克制：

- 只做**范围内**的事——不顺手重构无关代码、不加未要求的功能。
- 优先**复用**已有工具 / 模式 / 函数，而非另起炉灶。
- **偏离即停**：实现里发现与对齐卡不符（思路走不通 / 范围要扩 / 撞见意外）→ 停下、更新对齐卡、重新请求放行，不擅自扩张。

## 第六步：完成后回执 + 更新日志

干完（**或中途暂停**）都要回到 `JOURNAL.md` 更新本次条目，并向用户口头同样逐条回执：

- **状态**：未实现 / 部分实现 / 已完成。
- **对话重点 / 关键决策**：本次定了什么、为什么。
- **进展 / 遗留**：做了哪几条验收；⚠️ **没做完也必须写清遗留问题与「下次从哪续」**，否则下回接不上。
- **经验 / 教训**：可复用的坑或约定，抽到「📚 经验」区。
- 已完成的条目移入「✅ 已完成」区并精简；仍有遗留的留在「▶ 进行中」区**置顶**。

## 对齐日志模板（`docs/alignments/JOURNAL.md`）

```markdown
# 对齐日志
> 每次调用 align-before-coding：先读本文件（取经验、接续未完成）；结束时更新本次条目的状态与遗留。

## ▶ 进行中 / 有遗留
### <slug> — <一句话需求>   ·   状态：部分实现   ·   <YYYY-MM-DD>
- 目标：要做什么 + 为什么
- 验收：- [ ] …
- 范围：内 = …；外（不做 / 不碰）= …
- 实现思路：<用户给定，照抄、不得自行改向> 或 <agent 提议 + 关键取舍点>
- 落点（读码后）：`path/to/file:line` — 改什么
- 待澄清 / 假设：…
- 对话重点 / 关键决策：…
- 进展 / 遗留（下次从这里继续）：已完成 …；待续 - [ ] …
- 经验 / 教训：…

## 📚 经验 / 教训（跨需求复用）
- …

## ✅ 已完成（按时间倒序，精简）
- <date> <slug> — <一句话> ✅（要点 / 踩过的坑一行）
```

## 相关

- [`grill-with-docs`](../grill-with-docs/SKILL.md) / [`grill-me`](../../productivity/grill-me/SKILL.md) —— 已有方案时的盘问加固，与本 skill 互补（本 skill 在更上游：方案还没成形时的对齐）。
- [`to-prd`](../to-prd/SKILL.md) / [`to-issues`](../to-issues/SKILL.md) —— 对齐卡 / 日志条目可升级为 PRD / 工单。
- [`tdd`](../tdd/SKILL.md) / [`prototype`](../prototype/SKILL.md) —— 放行后的实现路径（测试先行 / 一次性原型探索）。
