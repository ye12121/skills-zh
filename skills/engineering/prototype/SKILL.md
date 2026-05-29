---
name: prototype
description: 在承诺某个设计之前构建一次性原型来充实它。在两个分支之间路由——一个可运行的终端应用回答状态/业务逻辑问题，或在同一路由下可切换的几种大相径庭的 UI 变体。当用户想原型化、对数据模型或状态机做合理性检查、为 UI 打草图、探索设计选项，或说"prototype this"、"let me play with it"、"try a few designs"时使用。 / Build a throwaway prototype to flesh out a design before committing to it. Routes between two branches — a runnable terminal app for state/business-logic questions, or several radically different UI variations toggleable from one route. Use when the user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options, or says "prototype this", "let me play with it", "try a few designs".
---

# 原型

原型是 **一次性的、用来回答某个问题的代码**。问题决定形状。

## 选分支

识别要回答的是哪个问题——从用户的提示、周围代码出发，或者询问用户（如果在）：

- **"这套逻辑/状态模型对不对？"** → [LOGIC.md](LOGIC.md)。构建一个小型可交互终端应用，把状态机推过纸面上难以推理的几种用例。
- **"这个应该长什么样？"** → [UI.md](UI.md)。在单一路由上生成几种大相径庭的 UI 变体，通过 URL search param 和悬浮底栏切换。

两个分支产出截然不同的产物——搞错就浪费了整个原型。如果问题确实模糊且用户联系不上，默认走与周围代码更匹配的分支（后端模块 → 逻辑；页面或组件 → UI），并在原型顶部说明这个假设。

## 两个分支共同的规则

1. **从第一天起就是一次性，并明确标记如此。** 把原型代码放在它将真正被使用的地方（紧挨着它在原型化的模块或页面），这样上下文一目了然——但起名时要让随便看一眼的人就能识别出这是原型，不是生产代码。对于一次性的 UI 路由，遵循项目已有的路由约定；不要发明新的顶层结构。
2. **一条命令就能跑。** 用项目现有 task runner 支持的任何方式——`pnpm <name>`、`python <path>`、`bun <path>` 等。用户必须不用动脑子就能启动它。
3. **默认不持久化。** 状态保存在内存里。持久化恰恰是原型在**检验**的东西，而不是它应当依赖的东西。如果问题明确涉及数据库，对着一个临时 DB 或本地文件，名称清楚标注 "PROTOTYPE — wipe me"。
4. **跳过打磨。** 不写测试，不做让原型**可运行**之外的错误处理，不抽象。重点是快速学到东西然后删掉。
5. **把状态显式呈现。** 每次动作后（逻辑分支）或每次切换变体后（UI 分支），打印或渲染相关的完整状态，让用户看见发生了什么变化。
6. **完成后删除或吸收。** 当原型回答了它的问题，要么删掉，要么把验证过的决定折回到真实代码里——不要让它在仓库里烂掉。

## 完成之后

原型唯一值得留下的东西是**答案**。把它捕获到耐用的地方（提交信息、ADR、Issue 或紧挨原型的 `NOTES.md`），连同它在回答的问题。如果用户在，捕获就是一段简短对话；如果不在，留一个占位，让他们（或你自己下次再来时）在删除原型前填上结论。
