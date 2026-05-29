# HTML 报告格式

架构评审被渲染为操作系统临时目录下一个自包含的 HTML 文件。Tailwind 和 Mermaid 都从 CDN 引用。Mermaid 可靠处理图形状的图表；手写的 divs 和 inline SVG 处理偏编辑性质的视觉（mass 图、剖面图）。两者混用——不要把什么都塞给 Mermaid，会显得通用乏味。

## 骨架

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

仓库名、日期，以及一个紧凑图例：实心方框 = 模块，虚线 = seam，红箭头 = 泄漏，粗暗方框 = 深模块。不要引言段落——直接进入候选。

## 候选卡片

图承担主要分量。文字稀疏、平实，直接用术语表（[LANGUAGE.md](LANGUAGE.md)）里的词，不要客套。

每个候选是一个 `<article>`：

- **Title** — 简短，命名这次深化（例如 "Collapse the Order intake pipeline"）。
- **Badge 行** — 推荐强度（`Strong` = 翠绿，`Worth exploring` = 琥珀，`Speculative` = 石板），加上依赖类别的标签（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **Files** — 等宽列表，`font-mono text-sm`。
- **Before / After 图** — 核心。两列并排。模式见下。
- **Problem** — 一句话。哪里痛。
- **Solution** — 一句话。改什么。
- **Wins** — 项目符号，每条 ≤6 个词。例如 "Tests hit one interface"、"Pricing logic stops leaking"、"Delete 4 shallow wrappers"。
- **ADR callout**（如适用）— 一行，放在琥珀色调框里。

不要解释段落。如果图需要一段文字才能看懂，就重画图。

## 图样式模式

挑契合候选的模式。混搭。不要让每张图看起来都一样——多样性是关键之一。

### Mermaid graph（依赖/调用流的主力）

当重点是"X 调 Y 调 Z，看看这一坨"时，用 Mermaid `flowchart` 或 `graph`。把它包在 Tailwind 风格的卡片里，免得像是空降。用 classDef 把泄漏边染红、深模块染暗。Sequence diagrams 适合 "before: 6 个回合; after: 1 个"。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手写盒子与箭头（当 Mermaid 的布局与你对抗时）

模块用带边框和标签的 `<div>`。箭头用 inline SVG 的 `<line>` 或 `<path>`，绝对定位在 relative 容器之上。当你想让 "after" 图看起来像一个粗边深模块、内部灰显——而 Mermaid 渲染不出那种分量——时，伸手去拿这个。

### 剖面（对分层浅化很好用）

水平条带堆叠（`h-12 border-l-4`）展示一个调用穿越的各层。Before：6 层薄薄的、每层什么都不做。After：1 条厚带，标注合并后的职责。

### Mass 图（对"接口宽度近乎实现宽度"很好用）

每个模块两个矩形——一个表示接口表面积，一个表示实现。Before：接口矩形几乎和实现矩形一样高（浅）。After：接口矩形短，实现矩形高（深）。

### 调用图坍缩

Before：嵌套盒子渲染的函数调用树。After：同一棵树坍缩为一个盒子，原本的调用淡化展示在内部。

## 风格指南

- 偏编辑感，而非企业 dashboard 感。慷慨留白。标题可用 serif（`font-serif` 配 stone/slate 很好）。
- 颜色克制：一个强调色（翠绿或靛蓝）+ 红表示泄漏 + 琥珀表示警告。
- 图保持约 320px 高，让 before/after 并排放得下而不需滚动。
- 图内模块标签用 `text-xs uppercase tracking-wider`——它们应读作示意图，不像 UI。
- 唯二的脚本是 Tailwind CDN 和 Mermaid ESM 引入。报告其他部分静态——没有应用代码、除 Mermaid 自身渲染外没有交互。

## 顶选推荐区

一张大点的卡片。候选名、一句为什么、指向其卡片的锚点链接。就这些。

## 语气

平白英语、简洁——但架构上的名词和动词直接用 [LANGUAGE.md](LANGUAGE.md) 里的。简洁不是漂移的借口。

**精确使用：** module、interface、implementation、depth、deep、shallow、seam、adapter、leverage、locality。

**绝不替换：** component、service、unit（替 module） · API、signature（替 interface） · boundary（替 seam） · layer、wrapper（指代 module 时）。

**契合风格的措辞：**

- "Order intake module is shallow — interface nearly matches the implementation."
- "Pricing leaks across the seam."
- "Deepen: one interface, one place to test."
- "Two adapters justify the seam: HTTP in prod, in-memory in tests."

**Wins 项目符号**用术语表里的词命名收益：*"locality: bugs concentrate in one module"*、*"leverage: one interface, N call sites"*、*"interface shrinks; implementation absorbs the wrappers"*。不要写 *"easier to maintain"* 或 *"cleaner code"*——这些不在术语表里，配不上一席之地。

不打太极、不清嗓子、不要 "it's worth noting that…"。一句话能变成项目符号就变。一条项目符号能砍就砍。一个术语不在 [LANGUAGE.md](LANGUAGE.md) 里，先找一个在的，再发明新的。
