# 好测试与坏测试

## 好的测试

**集成式**：通过真实接口测试，而不是 mock 内部部件。

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特征：

- 测试用户/调用者关心的行为
- 只使用公共 API
- 在内部重构后依然存活
- 描述「做什么」，而不是「怎么做」
- 一个测试一个逻辑断言

## 坏的测试

**实现细节测试**：与内部结构耦合。

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

警示信号：

- mock 内部协作者
- 测试私有方法
- 对调用次数/顺序断言
- 重构而行为未变时测试就坏
- 测试名描述的是「怎么做」而不是「做什么」
- 绕过接口、通过外部手段验证

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
