---
name: ubiquitous-language
description: 从当前对话中提取 DDD 风格的通用语言术语表，标记歧义并提议规范术语。保存到 UBIQUITOUS_LANGUAGE.md。当用户希望定义领域术语、构建术语表、固化术语、创建通用语言，或提到"领域模型"或"DDD"时使用。 / Extract a DDD-style ubiquitous language glossary from the current conversation, flagging ambiguities and proposing canonical terms. Saves to UBIQUITOUS_LANGUAGE.md. Use when user wants to define domain terms, build a glossary, harden terminology, create a ubiquitous language, or mentions "domain model" or "DDD".
disable-model-invocation: true
---

# 通用语言

从当前对话中提取并形式化领域术语为一致的术语表，保存到本地文件。

## 流程

1. **扫描对话**寻找领域相关的名词、动词和概念
2. **识别问题**：
   - 同一个词被用于不同概念（歧义）
   - 不同的词被用于同一个概念（同义）
   - 含糊或重载的术语
3. **提议一份规范术语表**，以有主张的术语选择呈现
4. **写入工作目录的 `UBIQUITOUS_LANGUAGE.md`**，使用下方格式
5. **在对话中输出一份摘要**

## 输出格式

写一个 `UBIQUITOUS_LANGUAGE.md` 文件，采用以下结构：

```md
# Ubiquitous Language

## Order lifecycle

| Term        | Definition                                              | Aliases to avoid      |
| ----------- | ------------------------------------------------------- | --------------------- |
| **Order**   | A customer's request to purchase one or more items      | Purchase, transaction |
| **Invoice** | A request for payment sent to a customer after delivery | Bill, payment request |

## People

| Term         | Definition                                  | Aliases to avoid       |
| ------------ | ------------------------------------------- | ---------------------- |
| **Customer** | A person or organization that places orders | Client, buyer, account |
| **User**     | An authentication identity in the system    | Login, account         |

## Relationships

- An **Invoice** belongs to exactly one **Customer**
- An **Order** produces one or more **Invoices**

## Example dialogue

> **Dev:** "When a **Customer** places an **Order**, do we create the **Invoice** immediately?"
> **Domain expert:** "No — an **Invoice** is only generated once a **Fulfillment** is confirmed. A single **Order** can produce multiple **Invoices** if items ship in separate **Shipments**."
> **Dev:** "So if a **Shipment** is cancelled before dispatch, no **Invoice** exists for it?"
> **Domain expert:** "Exactly. The **Invoice** lifecycle is tied to the **Fulfillment**, not the **Order**."

## Flagged ambiguities

- "account" was used to mean both **Customer** and **User** — these are distinct concepts: a **Customer** places orders, while a **User** is an authentication identity that may or may not represent a **Customer**.
```

## 规则

- **要有主张。** 同一概念有多个词时，挑最好的那一个，把其余作为应避免的别名列出。
- **明确标记冲突。** 如果一个术语在对话里被含糊使用，在 "Flagged ambiguities" 一节点出来并给出清晰建议。
- **只包含与领域专家相关的术语。** 跳过模块或类的名字，除非它们在领域语言中有含义。
- **定义要紧凑。** 最多一句。定义它**是**什么，而不是它做什么。
- **展示关系。** 用粗体术语名，并在显而易见处表达基数。
- **只包含领域术语。** 跳过通用编程概念（array、function、endpoint），除非它们有领域特定含义。
- **当出现自然聚类时把术语分到多张表**（按子领域、生命周期或角色分组）。每组一个标题一张表。如果所有术语属于单一连贯的领域，一张表也行——不必硬分组。
- **写一段示例对话。** 一段开发者与领域专家之间的简短对话（3-5 个来回），演示术语如何自然地交互。对话应澄清相关概念之间的边界，并展示术语被精确使用的样子。

<example>

## Example dialogue

> **Dev:** "How do I test the **sync service** without Docker?"

> **Domain expert:** "Provide the **filesystem layer** instead of the **Docker layer**. It implements the same **Sandbox service** interface but uses a local directory as the **sandbox**."

> **Dev:** "So **sync-in** still creates a **bundle** and unpacks it?"

> **Domain expert:** "Exactly. The **sync service** doesn't know which layer it's talking to. It calls `exec` and `copyIn` — the **filesystem layer** just runs those as local shell commands."

</example>

## 重新运行

在同一对话中再次被调用时：

1. 读现有的 `UBIQUITOUS_LANGUAGE.md`
2. 把后续讨论中的新术语合并进来
3. 如理解已演进则更新定义
4. 重新标记任何新歧义
5. 重写示例对话以纳入新术语
