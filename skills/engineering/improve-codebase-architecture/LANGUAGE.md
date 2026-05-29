# 语言

本 skill 给出的所有建议共用的词汇。精确使用这些术语——不要用 "component"、"service"、"API" 或 "boundary" 替换。一致的语言才是关键。

## 术语

**Module**
任何具有接口和实现的东西。刻意与规模无关——同等适用于函数、类、包，或跨层切片。
_Avoid_: unit, component, service。

**Interface**
调用方为了正确使用模块必须知道的一切。包括类型签名，也包括不变式、顺序约束、错误模式、必需的配置和性能特征。
_Avoid_: API, signature（太窄——它们只指类型级别的表面）。

**Implementation**
模块内部的东西——它的代码主体。与 **Adapter** 不同：一个东西可以是带大实现的小 adapter（Postgres repo），也可以是带小实现的大 adapter（内存伪造）。讨论 seam 时用 "adapter"；其他场合用 "implementation"。

**Depth**
接口处的 leverage——调用方（或测试）每学一份接口所能调动的行为量。当大量行为坐落在一个小接口之后时，模块是 **deep**。当接口几乎与实现一样复杂时，模块是 **shallow**。

**Seam** _(来自 Michael Feathers)_
能在不在该处编辑的情况下改变行为的地方。模块接口所在的**位置**。把 seam 放在哪里本身是一项设计决策，与背后放什么是分开的。
_Avoid_: boundary（与 DDD 的 bounded context 含义重载）。

**Adapter**
在 seam 处满足某个接口的具体东西。描述**角色**（它填哪个槽），而非内容（里面是什么）。

**Leverage**
调用方从 depth 中得到的东西。每学一份接口能拿到更多能力。一个实现回报到 N 个调用点和 M 个测试。

**Locality**
维护者从 depth 中得到的东西。变化、bug、知识、验证集中在一处，而不是分散到调用方。修一次，全修好。

## 原则

- **Depth 是接口的属性，不是实现的属性。** 一个深模块的内部可以由小的、可 mock 的、可替换的部件组成——它们只是不在接口上。一个模块可以有 **内部 seams**（对其实现私有，由它自己的测试使用），也可以在接口处有 **外部 seam**。
- **删除测试。** 设想删掉这个模块。如果复杂度消失了，模块没有藏任何东西（它就是一个透传）。如果复杂度跨 N 个调用方重新出现，模块在挣自己的饭。
- **接口就是测试面。** 调用方和测试穿过同一个 seam。如果你想测**接口之后**的东西，模块的形状很可能不对。
- **一个 adapter 意味着假想的 seam。两个 adapter 才意味着真的 seam。** 不要因为没有东西真的在它上面变化就引入 seam。

## 关系

- 一个 **Module** 恰有一个 **Interface**（它呈现给调用方和测试的表面）。
- **Depth** 是 **Module** 的属性，相对其 **Interface** 测量。
- **Seam** 是 **Module** 的 **Interface** 所在之处。
- **Adapter** 坐在 **Seam** 上并满足 **Interface**。
- **Depth** 为调用方产出 **Leverage**，为维护者产出 **Locality**。

## 被拒绝的提法

- **Depth 作为实现行数与接口行数之比**（Ousterhout）：奖励给实现加水。我们用 depth-as-leverage 代替。
- **"Interface" 仅指 TypeScript `interface` 关键字或类的公有方法**：太窄——这里的 interface 包含调用方必须知道的每一项事实。
- **"Boundary"**：与 DDD 的 bounded context 重载。说 **seam** 或 **interface**。
