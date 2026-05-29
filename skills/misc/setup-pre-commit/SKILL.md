---
name: setup-pre-commit
description: 在当前仓库中配置 Husky pre-commit 钩子，包含 lint-staged（Prettier）、类型检查和测试。当用户希望添加 pre-commit 钩子、配置 Husky、配置 lint-staged，或希望在提交时进行格式化/类型检查/测试时使用。 / Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing.
---

# 配置 Pre-Commit 钩子

## 此 skill 会配置什么

- **Husky** pre-commit 钩子
- **lint-staged**，对所有已暂存文件运行 Prettier
- **Prettier** 配置（若缺失）
- pre-commit 钩子中的 **typecheck** 与 **test** 脚本

## 步骤

### 1. 检测包管理器

检查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。哪一个存在就使用哪一个。无法判断时默认使用 npm。

### 2. 安装依赖

作为 devDependencies 安装：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

这会创建 `.husky/` 目录，并向 package.json 添加 `prepare: "husky"`。

### 4. 创建 `.husky/pre-commit`

写入此文件（Husky v9+ 不需要 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**适配**：将 `npm` 替换为检测到的包管理器。如果仓库 package.json 中没有 `typecheck` 或 `test` 脚本，请省略对应行并告知用户。

### 5. 创建 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 创建 `.prettierrc`（若缺失）

仅当不存在 Prettier 配置时才创建。使用以下默认值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 验证

- [ ] `.husky/pre-commit` 存在且可执行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 脚本为 `"husky"`
- [ ] 存在 `prettier` 配置
- [ ] 运行 `npx lint-staged` 验证其可用

### 8. 提交

暂存所有变更/新建的文件并提交，提交消息为：`Add pre-commit hooks (husky + lint-staged + prettier)`

提交会触发新的 pre-commit 钩子——这是一次很好的冒烟测试，可以验证一切正常。

## 备注

- Husky v9+ 在钩子文件中不需要 shebang
- `prettier --ignore-unknown` 会跳过 Prettier 无法解析的文件（图像等）
- pre-commit 先运行 lint-staged（速度快、仅作用于已暂存文件），再运行完整的 typecheck 和测试
