# 为可测试性设计接口

好的接口让测试变得自然：

1. **接收依赖，不要在内部创建依赖**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **返回结果，不要产生副作用**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **小表面积**
   - 方法越少 = 需要的测试越少
   - 参数越少 = 测试搭建越简单
