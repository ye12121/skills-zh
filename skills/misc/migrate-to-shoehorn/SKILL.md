---
name: migrate-to-shoehorn
description: 将测试文件中的 `as` 类型断言迁移到 @total-typescript/shoehorn。当用户提到 shoehorn、希望替换测试中的 `as`，或需要部分测试数据时使用。 / Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data.
---

# 迁移到 Shoehorn

## 为什么用 shoehorn？

`shoehorn` 让你在测试中传入部分数据，同时让 TypeScript 满意。它用类型安全的替代方案取代了 `as` 断言。

**仅限测试代码。** 切勿在生产代码中使用 shoehorn。

`as` 在测试中存在的问题：

- 被反复告诫不要使用
- 必须手动指定目标类型
- 需要双重 as（`as unknown as Type`）来表达故意错误的数据

## 安装

```bash
npm i @total-typescript/shoehorn
```

## 迁移模式

### 大对象但只需要少数属性

之前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...20 more properties
};

it("gets user by id", () => {
  // Only care about body.id but must fake entire Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...fake all 20 properties
  });
});
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

之前：

```ts
getUser({ body: { id: "123" } } as Request);
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

之前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // wrong type on purpose
```

之后：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 何时使用哪一个

| 函数            | 适用场景                                       |
| --------------- | ---------------------------------------------- |
| `fromPartial()` | 传入部分数据但仍能通过类型检查                 |
| `fromAny()`     | 传入故意错误的数据（保留自动补全）             |
| `fromExact()`   | 强制传入完整对象（之后可换成 fromPartial）     |

## 工作流程

1. **收集需求** —— 询问用户：
   - 哪些测试文件中的 `as` 断言带来了问题？
   - 它们是否在处理只关心部分属性的大对象？
   - 是否需要传入故意错误的数据来测试错误场景？

2. **安装并迁移**：
   - [ ] 安装：`npm i @total-typescript/shoehorn`
   - [ ] 查找带有 `as` 断言的测试文件：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 将 `as Type` 替换为 `fromPartial()`
   - [ ] 将 `as unknown as Type` 替换为 `fromAny()`
   - [ ] 添加来自 `@total-typescript/shoehorn` 的 import
   - [ ] 运行类型检查以验证
