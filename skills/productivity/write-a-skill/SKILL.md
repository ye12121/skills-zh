---
name: write-a-skill
description: 创建新的 agent skills，具备恰当的结构、渐进式披露与捆绑资源。当用户希望创建、编写或构建新的 skill 时使用。 / Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill.
---

# 编写 Skill

## 流程

1. **收集需求** —— 询问用户：
   - 该 skill 涵盖什么任务/领域？
   - 应处理哪些具体用例？
   - 是否需要可执行脚本，还是仅需说明？
   - 是否有需要纳入的参考资料？

2. **起草 skill** —— 创建：
   - SKILL.md，包含简明说明
   - 若内容超过 500 行，添加额外参考文件
   - 若需确定性操作，添加工具脚本

3. **与用户复核** —— 展示草稿并询问：
   - 是否覆盖了你的用例？
   - 是否有遗漏或不清晰之处？
   - 是否有章节需要更详细/更简略？

## Skill 结构

```
skill-name/
├── SKILL.md           # 主说明（必需）
├── REFERENCE.md       # 详细文档（如需）
├── EXAMPLES.md        # 使用示例（如需）
└── scripts/           # 工具脚本（如需）
    └── helper.js
```

## SKILL.md 模板

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Link to separate files: See [REFERENCE.md](REFERENCE.md)]
```

## description 要求

description 是**你的 agent 在决定加载哪个 skill 时唯一能看到的内容**。它会与所有已安装的其他 skills 一并出现在系统提示中。你的 agent 阅读这些描述，并根据用户请求挑选相关 skill。

**目标**：给 agent 足够的信息以了解：

1. 该 skill 提供什么能力
2. 何时/为何触发它（具体关键词、上下文、文件类型）

**格式**：

- 最多 1024 字符
- 以第三人称撰写
- 第一句：它做什么
- 第二句："Use when [specific triggers]"

**好示例**：

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**坏示例**：

```
Helps with documents.
```

坏示例没有给 agent 任何方式将其与其他文档相关的 skills 区分开来。

## 何时添加脚本

在以下情况添加工具脚本：

- 操作是确定性的（校验、格式化）
- 同样的代码会被反复生成
- 错误需要显式处理

脚本相比生成代码可节省 token 并提升可靠性。

## 何时拆分文件

在以下情况拆分为独立文件：

- SKILL.md 超过 100 行
- 内容涉及不同领域（财务 vs 销售 schema）
- 高级功能很少使用

## 复核清单

起草后核查：

- [ ] description 含触发条件（"Use when..."）
- [ ] SKILL.md 不超过 100 行
- [ ] 无时效性信息
- [ ] 术语一致
- [ ] 包含具体示例
- [ ] 引用仅一层深度
