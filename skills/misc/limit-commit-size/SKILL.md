---
name: limit-commit-size
description: 在当前仓库中安装 git 钩子（pre-commit / pre-push），强制每次提交和每次推送的改动都少于 1000 行；超限即拒绝并提示如何拆分。无论由 agent、人工命令行还是其他工具发起都会生效。当用户希望限制单次提交/推送的改动行数、把大提交拆成多份、为提交体积设上限，或要求“每次 commit/push 少于 N 行”时使用。 / Install git hooks (pre-commit / pre-push) in the current repo that enforce fewer than 1000 changed lines per commit and per push, rejecting oversized ones with guidance on how to split. Fires for commits/pushes made by the agent, by hand, or by any other tool. Use when the user wants to cap changed lines per commit/push, split large commits, or require "each commit/push under N lines".
---

# 限制提交 / 推送体积

让每一次 `git commit` 和 `git push` 的改动都保持在 **1000 行以内**，超限就阻止并提示拆分。

## 关键前提：为什么必须用 git 钩子

skill 本身只是 agent 读取的指令，**只能约束 agent 自己的行为**——它无法拦截人工敲下的 `git commit`、IDE 按钮提交、或别的工具发起的提交。

要做到「无论 agent、人工还是其他方式都生效」，唯一可靠的机制是 **git 钩子**：git 在每次提交/推送前都会运行它们，与谁触发无关。因此本 skill 的核心就是安装 `pre-commit` 和 `pre-push` 钩子。

- `pre-commit` —— 统计**本次提交**已暂存改动的「新增 + 删除」行数，超过 1000 行则拒绝。
- `pre-push` —— 统计**本次推送**中远端尚未拥有的提交累计改动行数，超过 1000 行则拒绝。

二进制文件不计入行数；上限可用环境变量 `COMMIT_LINE_LIMIT` / `PUSH_LINE_LIMIT` 覆盖。

## 安装步骤

钩子脚本已随本 skill 提供，位于本目录的 `hooks/pre-commit` 与 `hooks/pre-push`。

### 1. 确认在 git 仓库内

```bash
git rev-parse --is-inside-work-tree
```

不是仓库就先 `git init`（或征求用户意见）。

### 2. 选择安装方式

**首选：纳入版本管理、团队共享（`core.hooksPath`）**

把钩子放到仓库内一个被跟踪的目录，并让 git 使用它。这样克隆仓库的每个人都会得到同样的限制。

```bash
mkdir -p .githooks
cp <此skill>/hooks/pre-commit  .githooks/pre-commit
cp <此skill>/hooks/pre-push    .githooks/pre-push
chmod +x .githooks/pre-commit .githooks/pre-push
git config core.hooksPath .githooks
```

> 把 `.githooks/` 一并提交。注意 `core.hooksPath` 是本地配置，克隆者仍需各自运行一次 `git config core.hooksPath .githooks`——可在 README 或 `npm prepare` 脚本里提醒。

**备选：仅本机生效（`.git/hooks`）**

不想改动仓库内容时，直接装到 `.git/hooks/`（不会被提交，只对本机有效）：

```bash
cp <此skill>/hooks/pre-commit  .git/hooks/pre-commit
cp <此skill>/hooks/pre-push    .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/pre-push
```

### 3. 已有 Husky / 其他钩子时

如果仓库已用 Husky（`.husky/`）或已存在同名钩子，**不要覆盖**。把行数检查追加进现有钩子即可，例如在 `.husky/pre-commit` 末尾加一行调用，或把检查逻辑并入现有脚本。可参考 [setup-pre-commit](../setup-pre-commit/SKILL.md)。

### 4. 验证

```bash
# 应通过
printf 'a\nb\n' > _probe.txt && git add _probe.txt && git commit -m "probe" && git reset --soft HEAD~1 && git restore --staged _probe.txt && rm _probe.txt
# 制造一个 >1000 行的暂存改动，确认被拒绝
seq 1 1500 > _big.txt && git add _big.txt && git commit -m "should fail"   # 预期失败
git restore --staged _big.txt && rm _big.txt
```

## Agent 工作流：如何拆分

钩子负责「把关并拒绝」；真正的拆分要由发起提交的人或 agent 完成。agent 在提交前应主动按下面的方式保证每份 < 1000 行，避免撞上钩子。

**提交前自检改动行数：**

```bash
git diff --cached --numstat | awk '{if($1!="-")a+=$1; if($2!="-")d+=$2} END{print a+d+0}'
```

**超过 1000 行时，拆成多个提交：**

1. **优先按逻辑边界拆**——一个功能点 / 一个目录 / 一类改动算一份，而不是机械按行切。
2. 取消整体暂存后分批提交：
   ```bash
   git reset                      # 保留工作区改动，清空暂存
   git add path/to/group-a        # 第一份
   git commit -m "..."            # 钩子会校验这份 < 1000 行
   git add path/to/group-b        # 第二份
   git commit -m "..."
   ```
3. 单个文件本身就超 1000 行时，用 `git add -p` 按 hunk 分批暂存、分多次提交。
4. 每份提交后，钩子会再次校验；如仍超限，继续细分。

**推送同理——累计超 1000 行时分批 push：**

`pre-push` 校验的是「本次推送相对远端新增的全部提交」的累计行数。若多个小提交加起来仍 > 1000 行，要逐段推送，每段累计 < 1000 行：

```bash
git push origin <较早的commit-sha>:<分支名>   # 先推一批
git push origin <分支名>                       # 再推其余
```

## 绕过（仅在确有必要时）

- 单次提交跳过：`git commit --no-verify`
- 单次推送跳过：`git push --no-verify`

应把这些当成例外而非常态。如果某次大改动确实无法拆分（如自动生成文件、批量格式化），用 `--no-verify` 并在提交信息里说明原因。

## 备注

- 行数 = 该范围 `git diff --numstat` 的「新增 + 删除」之和，二进制文件（numstat 显示 `-`）不计入。
- 调整上限：`COMMIT_LINE_LIMIT=500 git commit ...`，或直接改钩子里的默认值。
- 本 skill 关注「体积」；若还想在提交时跑格式化 / 类型检查 / 测试，见 [setup-pre-commit](../setup-pre-commit/SKILL.md)；若想拦截危险 git 命令，见 [git-guardrails-claude-code](../git-guardrails-claude-code/SKILL.md)。
