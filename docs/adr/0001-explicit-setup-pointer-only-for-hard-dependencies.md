# 仅对硬依赖明确指向 `/setup-matt-pocock-skills`

Engineering skills 依赖由 `/setup-matt-pocock-skills` 种下的每仓库配置（Issue 追踪器、分诊标签词汇表、领域文档布局）。有些 skills 没有该配置就无法有意义地运行——它们必须发布到特定的 Issue 追踪器或应用特定的标签字符串。其他 skills 仅用它来锐化输出（词汇、ADR 感知），即使没有也能优雅降级。

我们将它们分为**硬依赖**和**软依赖** skills：

- **硬依赖**（`to-issues`、`to-prd`、`triage`）——包含一条明确的一句话：_"……应已提供给你——若没有，请运行 `/setup-matt-pocock-skills`。"_ 没有该映射，输出就是错的，而不只是模糊。
- **软依赖**（`diagnose`、`tdd`、`improve-codebase-architecture`、`zoom-out`）——只在含糊的散文中引用"项目的领域术语表"和"你正在触碰区域的 ADR"。如果文档不存在，skill 仍能工作；只是输出不够锐利。

这种划分使软依赖 skills 保持 token 轻量，并避免将设置指示符照搬到不承担实际作用的地方。
