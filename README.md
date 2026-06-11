
# 给真正工程师的 Skills

[![skills.sh](https://skills.sh/b/mattpocock/skills)](https://skills.sh/mattpocock/skills)

我每天用来做真正工程工作的 agent skills——不是 vibe coding（凭感觉编码）。

开发真正的应用很难。GSD、BMAD 和 Spec-Kit 这类方法试图通过接管流程来帮助你。但它们这么做时，会剥夺你的控制权，让流程中的 bug 难以解决。

这些 skills 设计得小巧、易于调整、可组合。它们适用于任何模型。它们基于数十年的工程经验。随意改造它们。让它们变成你自己的。享受。

如果你想了解这些 skills 的更新，以及我创建的任何新 skills，可以加入约 6 万其他开发者订阅我的 newsletter：


## 安装

每个 skill 就是一个含 `SKILL.md` 的文件夹，遵循跨工具的 [Agent Skills](https://agentskills.io) 开放标准——Claude Code、Codex 等都能识别。装好后用 `/<skill 名>` 触发，或让 agent 根据描述自动调用。

### 方式一：skills.sh 安装器（跨 agent，最省事）

它会自动探测你装了哪些编码 agent，并把 skill 放到各自正确的目录：

```bash
npx skills@latest add ye12121/skills-zh
```

按提示勾选要装的 skill 和目标 agent 即可。

### 方式二：手动安装到 Claude Code

把想要的 skill 文件夹复制到 skills 目录：

```bash
# 全局（所有项目可用）
cp -r skills/misc/limit-commit-size ~/.claude/skills/limit-commit-size

# 或仅某个项目
cp -r skills/misc/limit-commit-size /path/to/your-project/.claude/skills/limit-commit-size
```

之后在 Claude Code 里输入 `/limit-commit-size` 触发（换文件夹路径即可安装其它 skill）。

### 方式三：手动安装到 Codex

Codex 从 `.agents/skills/` 读取 skill，复制方式相同：

```bash
# 全局（用户级）
cp -r skills/misc/limit-commit-size ~/.agents/skills/limit-commit-size

# 或仅当前仓库
cp -r skills/misc/limit-commit-size .agents/skills/limit-commit-size
```

在 Codex 里用 `/skills` 选择，或在 prompt 中用 `$` 提及；任务匹配描述时也会被自动调用。改动 skill 后若没生效，重启 Codex。

### 安装后必做

- **先手动运行一次 `/setup-matt-pocock-skills`**（每个仓库一次）。它会写好 `CLAUDE.md` / `AGENTS.md` 里的 `## Agent skills` 块和 `docs/agents/`，告诉其余 skill 本仓库的 Issue 追踪器、分诊标签和领域文档布局。不跑它，`to-issues` / `to-prd` / `triage` / `diagnose` / `tdd` 等会缺上下文。
- **`limit-commit-size` 还需另装 git 钩子**才能对所有 commit/push（含手动）生效——skill 装好只让 agent 知道"该怎么做"，真正的拦截靠 git 钩子。在目标仓库执行 `git config core.hooksPath .githooks`（或把钩子拷到 `.git/hooks`），详见该 skill 的 `SKILL.md`。

## 为什么有这些 Skills

我构建这些 skills 是为了修复我在 Claude Code、Codex 和其他编码 agent 中看到的常见失败模式。

### #1：Agent 没做我想要的事

> "没人确切知道自己想要什么"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**问题**。软件开发中最常见的失败模式是不一致。你以为开发者明白你想要什么。然后看到他们的成果——你才意识到他们根本没理解你。

在 AI 时代也一样。你和 agent 之间存在沟通鸿沟。修复方式是一次**盘问环节**——让 agent 就你要构建的东西向你提出详细问题。

**修复方法**是使用：

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) - 用于非代码场景
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) - 与 [`/grill-me`](./skills/productivity/grill-me/SKILL.md) 相同，但增加了更多好东西（见下文）

这些是我最受欢迎的 skills。它们帮助你在开始之前与 agent 对齐，并深入思考你要做的变更。在你想做任何变更时_每次_都要使用它们。

### #2：Agent 太啰嗦了

> 有了通用语言，开发者之间的对话和代码的表达都源自相同的领域模型。
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**问题**：项目开始时，开发者和他们要为之构建软件的人（领域专家）通常说着不同的语言。

我对我的 agent 也有同样的感受。Agent 通常被丢进一个项目，然后被要求边做边搞懂术语。所以它们用 20 个词去说 1 个词就能说清的事。

**修复方法**是共享语言。这是一份帮助 agent 解码项目中所用术语的文档。

<details>
<summary>
示例
</summary>

这是一个来自我的 `course-video-manager` 仓库的 [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md) 示例。哪一个更易读？

- **之前**："当课程某个章节里的一节课变得'真实'时（即在文件系统中获得一个位置），会出现问题"
- **之后**："物化级联（materialization cascade）有个问题"

这种简洁性会在一个又一个会话中带来回报。

</details>

这已内置于 [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) 中。这是一个盘问环节，但它会帮你与 AI 建立共享语言，并在 ADR 中记录难以解释的决策。

很难解释这有多强大。这可能是本仓库中最酷的单个技巧。试试就知道了。

> [!TIP]
> 共享语言除了减少啰嗦外，还有许多其他好处：
>
> - **变量、函数和文件命名一致**，使用共享语言
> - 因此，**代码库对 agent 来说更易导航**
> - Agent **在思考上花费的 token 也更少**，因为它有更简洁的语言可用

### #3：代码不工作

> "始终采取小而审慎的步骤。反馈的速度就是你的速度上限。永远不要承担过大的任务。"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**问题**：假设你和 agent 在要构建什么上已经一致。如果 agent _仍然_产出垃圾，怎么办？

是时候审视你的反馈循环了。如果没有关于代码实际运行的反馈，agent 就是在盲飞。

**修复方法**：你需要常规的一整套反馈循环：静态类型、浏览器访问以及自动化测试。

对于自动化测试，红-绿-重构循环至关重要。这是 agent 先写一个失败的测试，然后修复测试。这有助于给 agent 提供一致的反馈水平，从而产出好得多的代码。

我构建了一个 **[`/tdd`](./skills/engineering/tdd/SKILL.md) skill**，你可以将它接入任何项目。它鼓励红-绿-重构，并为 agent 提供了大量关于什么是好测试和坏测试的指导。

对于调试，我还构建了一个 **[`/diagnose`](./skills/engineering/diagnose/SKILL.md)** skill，将最佳调试实践封装到一个简单的循环中。

### #4：我们构建了一个大泥球

> "_每天_都要投入到系统设计中。"
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "最好的模块是深的。它们允许通过简单的接口访问大量功能。"
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**问题**：大多数用 agent 构建的应用既复杂又难以更改。因为 agent 可以极大加速编码，它们也加速了软件熵增。代码库以前所未有的速度变得更复杂。

**修复方法**是一种 AI 驱动开发的全新激进方法：关注代码的设计。

这一点内置于这些 skills 的每一层：

- [`/to-prd`](./skills/engineering/to-prd/SKILL.md) 在创建 PRD 之前会先就你要触碰哪些模块向你提问
- [`/zoom-out`](./skills/engineering/zoom-out/SKILL.md) 告诉 agent 在整个系统的上下文中解释代码

并且关键的是，[`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) 帮助你拯救已经变成大泥球的代码库。我建议每隔几天就在你的代码库上运行一次。

### 总结

软件工程基本功比以往任何时候都更重要。这些 skills 是我将这些基本功凝炼为可重复实践的最大努力，帮你交付职业生涯中最好的应用。享受。

## 如何使用这些 Skills

这些 skill 不是孤立的工具，而是设计成**一条流水线**——围绕"修复 agent 四种常见失败模式"逐环相扣。下面是推荐的使用方式。

### 推荐工作流

```
① setup-matt-pocock-skills        ← 每个仓库只跑一次（前置依赖）
        │
② grill-me / grill-with-docs      ← 动手前先对齐需求、磨术语
        │
③ to-prd → to-issues               ← 把对齐结果变成 PRD 和可认领的 Issue
        │
④ tdd / diagnose                   ← 用红-绿-重构和诊断循环真正写代码 / 修 bug
        │
⑤ zoom-out / improve-codebase-architecture ← 持续维护设计健康
```

两条最重要的原则：

- **第 ① 步是硬前置。** [`setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md) 会在 `CLAUDE.md` 写入 `## Agent skills` 块、建立 `docs/agents/`，告诉其余 skill：本仓库用什么 Issue 追踪器、分诊标签词汇、领域文档放在哪里。它特意禁用了模型自动调用，**必须你手动运行 `/setup-matt-pocock-skills` 触发**。不跑它，`to-issues` / `to-prd` / `triage` / `diagnose` / `tdd` 等都会缺少上下文。
- **开工前先盘问。** [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) / [`grill-me`](./skills/productivity/grill-me/SKILL.md) 是作者最受欢迎的 skill——在你想做任何变更时**每次都用**，用来弥补你和 agent 之间的沟通鸿沟。

### 分场景速查

**Engineering（每天写代码）**

| 什么时候 | 用哪个 |
|---|---|
| 新仓库第一次接入 | [`setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md)（手动，仅一次）|
| 开工前对齐需求 | [`grill-me`](./skills/productivity/grill-me/SKILL.md)（非代码）/ [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md)（代码，并更新 CONTEXT.md + ADR）|
| 把讨论变成文档 / 工单 | [`to-prd`](./skills/engineering/to-prd/SKILL.md) → [`to-issues`](./skills/engineering/to-issues/SKILL.md) |
| 写功能 / 修 bug | [`tdd`](./skills/engineering/tdd/SKILL.md)（测试先行）/ [`diagnose`](./skills/engineering/diagnose/SKILL.md)（疑难 bug 诊断循环）|
| 看不懂一段代码 | [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) |
| 代码库变乱了 | [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md)（建议每隔几天跑一次）|
| 管理 Issue | [`triage`](./skills/engineering/triage/SKILL.md) |
| 探索设计方案 | [`prototype`](./skills/engineering/prototype/SKILL.md)（一次性原型）|

**Productivity（通用，不限于代码）**

- [`handoff`](./skills/productivity/handoff/SKILL.md) — 把当前对话压缩成交接文档，方便换一个 agent 接着干。
- [`caveman`](./skills/productivity/caveman/SKILL.md) — 压缩沟通模式，省约 75% token 而不损失技术准确性。
- [`write-a-skill`](./skills/productivity/write-a-skill/SKILL.md) — 按本仓规范创建新的 skill。
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — 非代码场景的盘问环节。

**Misc（按需）**

- [`setup-pre-commit`](./skills/misc/setup-pre-commit/SKILL.md) — Husky + lint-staged + 类型检查 + 测试。
- [`git-guardrails-claude-code`](./skills/misc/git-guardrails-claude-code/SKILL.md) — 拦截危险 git 命令。
- [`guard-dangerous-ops-claude-code`](./skills/misc/guard-dangerous-ops-claude-code/SKILL.md) — 拦截不可逆的危险操作（rm -rf、sudo、publish 等），致命直拒、其余确认后放行。
- [`limit-commit-size`](./skills/misc/limit-commit-size/SKILL.md) — 限制每次 commit / push 的改动行数。
- [`migrate-to-shoehorn`](./skills/misc/migrate-to-shoehorn/SKILL.md)、[`scaffold-exercises`](./skills/misc/scaffold-exercises/SKILL.md) — 特定场景工具。

> `personal/`、`in-progress/`、`deprecated/` 三类不建议依赖：分别绑定作者个人设置、尚未完成、已废弃。

### 一个典型的完整闭环

1. 新项目里手动运行 `/setup-matt-pocock-skills`（仅一次）。
2. 用 `grill-with-docs` 就要做的变更对齐需求、沉淀术语。
3. `to-prd` 生成 PRD，再用 `to-issues` 拆成可认领的 Issue。
4. 用 `tdd` 一个纵向切片一个切片地实现；卡住时用 `diagnose`。
5. 阶段性运行 `improve-codebase-architecture` 做架构体检。

## 参考

### Engineering

我每天用于代码工作的 skills。

- **[align-before-coding](./skills/engineering/align-before-coding/SKILL.md)** — 动手写代码前先和你对齐「目标」与「实现思路」：先读累积的「对齐日志」（取历史经验、接续未完成项）→ 读真实代码 → 产出可确认的对齐卡（目标 / 验收 / 范围内外 / 思路 / 落点 / 待澄清），提问都带可选项，未明确放行前不写一行代码；结束时把状态与遗留问题写回日志以便续作。防止 agent 自由发挥跑偏。
- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — 针对疑难 bug 和性能回归的有纪律诊断循环：重现 → 最小化 → 提出假设 → 加埋点 → 修复 → 回归测试。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — 盘问环节，对照已有领域模型质疑你的计划，磨练术语，并就地更新 `CONTEXT.md` 和 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)** — 通过分诊角色的状态机对 Issue 进行分诊。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — 在代码库中寻找深化机会，依据 `CONTEXT.md` 中的领域语言和 `docs/adr/` 中的决策。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)** — 搭建其他 engineering skills 消费的每仓库配置（Issue 追踪器、分诊标签词汇表、领域文档布局）。在使用 `to-issues`、`to-prd`、`triage`、`diagnose`、`tdd`、`improve-codebase-architecture` 或 `zoom-out` 之前，每个仓库运行一次。
- **[tdd](./skills/engineering/tdd/SKILL.md)** — 测试驱动开发，使用红-绿-重构循环。一次构建一个纵向切片来实现功能或修复 bug。
- **[to-issues](./skills/engineering/to-issues/SKILL.md)** — 使用纵向切片，将任何计划、规格说明或 PRD 拆解为可独立认领的 GitHub Issue。
- **[to-prd](./skills/engineering/to-prd/SKILL.md)** — 将当前对话上下文转化为 PRD 并作为 GitHub Issue 提交。无需访谈——只是综合你已经讨论过的内容。
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — 让 agent 拉远视角，对一段不熟悉的代码给出更广的上下文或更高层次的视角。
- **[prototype](./skills/engineering/prototype/SKILL.md)** — 构建一次性原型来打磨设计——可以是处理状态/业务逻辑问题的可运行终端应用，或是几个差异巨大的 UI 变体，可从单一路由切换。

### Productivity

通用工作流工具，不针对代码。

- **[caveman](./skills/productivity/caveman/SKILL.md)** — 超压缩沟通模式。通过去掉填充词将 token 用量削减约 75%，同时保持完整技术准确性。
- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — 就一个计划或设计被持续不断地访谈，直到决策树的每个分支都被解决。
- **[handoff](./skills/productivity/handoff/SKILL.md)** — 将当前对话压缩为一份交接文档，以便另一个 agent 可以继续工作。
- **[write-a-skill](./skills/productivity/write-a-skill/SKILL.md)** — 创建具有恰当结构、渐进式披露和打包资源的新 skills。

### Misc

我留着但很少使用的工具。

- **[git-guardrails-claude-code](./skills/misc/git-guardrails-claude-code/SKILL.md)** — 设置 Claude Code 钩子，在危险 git 命令（push、reset --hard、clean 等）执行之前阻止它们。
- **[guard-dangerous-ops-claude-code](./skills/misc/guard-dangerous-ops-claude-code/SKILL.md)** — 设置 Claude Code PreToolUse 钩子，在执行前拦截不可逆的危险 Bash 操作：致命的（rm -rf /、写块设备、mkfs）直接拒绝，危险但常见的（rm -rf 某目录、sudo、kill -9、publish、curl|sh 等）弹出确认让用户 double check 后才放行。
- **[limit-commit-size](./skills/misc/limit-commit-size/SKILL.md)** — 安装 git 钩子，强制每次 commit / push 的改动少于 1000 行，超限即拒绝并提示如何拆分（agent、人工、其他工具一律生效）。
- **[migrate-to-shoehorn](./skills/misc/migrate-to-shoehorn/SKILL.md)** — 将测试文件从 `as` 类型断言迁移到 @total-typescript/shoehorn。
- **[scaffold-exercises](./skills/misc/scaffold-exercises/SKILL.md)** — 创建带有章节、问题、解答和讲解的练习目录结构。
- **[setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md)** — 设置带有 lint-staged、Prettier、类型检查和测试的 Husky 预提交钩子。
