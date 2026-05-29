# CONTEXT.md 格式

## 结构

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## 规则

- **要有主张。** 同一个概念有多个词时，挑最好的那一个，把其余作为应避免的别名列出。
- **明确标记冲突。** 如果一个术语用得含糊，在"Flagged ambiguities"中点出来并给出清晰的解决方案。
- **定义要紧凑。** 最多一到两句。定义它**是**什么，而不是它做什么。
- **展示关系。** 用粗体术语名，并在显而易见处表达基数。
- **只包含该项目上下文专属的术语。** 通用编程概念（超时、错误类型、工具模式）即使项目大量使用也不属于这里。添加术语前问：这是这个上下文独有的概念，还是通用编程概念？只有前者属于这里。
- **当出现自然聚类时用子标题分组**。如果所有术语属于单一连贯的领域，扁平列表也行。
- **写一段示例对话。** 一段开发者与领域专家之间的对话，演示术语如何自然地交互，并澄清相关概念之间的边界。

## 单上下文 vs 多上下文仓库

**单上下文（多数仓库）：** 仓库根目录一个 `CONTEXT.md`。

**多上下文：** 仓库根目录的 `CONTEXT-MAP.md` 列出各上下文、它们在哪里以及彼此如何关联：

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

skill 推断该应用哪种结构：

- 如果 `CONTEXT-MAP.md` 存在，读它以找到各上下文
- 如果只存在根 `CONTEXT.md`，单上下文
- 如果都不存在，第一个术语被解析时再懒创建一个根 `CONTEXT.md`

存在多个上下文时，推断当前话题与哪个相关。不清楚就问。
