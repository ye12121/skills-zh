---
name: git-guardrails-claude-code
description: 配置 Claude Code 钩子，在执行前拦截危险的 git 命令（push、reset --hard、clean、branch -D 等）。当用户希望阻止破坏性 git 操作、添加 git 安全钩子或在 Claude Code 中屏蔽 git push/reset 时使用。 / Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code.
---

# 配置 Git 护栏

配置一个 PreToolUse 钩子，在 Claude 执行危险 git 命令之前拦截并阻止它们。

## 被阻止的命令

- `git push`（包括 `--force` 在内的所有变体）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被阻止时，Claude 会收到一条消息，告知其无权访问这些命令。

## 步骤

### 1. 询问范围

询问用户：是仅为**当前项目**安装（`.claude/settings.json`），还是为**所有项目**安装（`~/.claude/settings.json`）？

### 2. 复制钩子脚本

随附的脚本位于：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根据范围将其复制到目标位置：

- **项目级**：`.claude/hooks/block-dangerous-git.sh`
- **全局**：`~/.claude/hooks/block-dangerous-git.sh`

使用 `chmod +x` 赋予可执行权限。

### 3. 在 settings 中添加钩子

添加到对应的 settings 文件：

**项目级**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**全局**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果 settings 文件已存在，请将钩子合并到已有的 `hooks.PreToolUse` 数组中——不要覆盖其他设置。

### 4. 询问是否定制

询问用户是否希望在被阻止列表中添加或移除某些模式。相应地编辑复制的脚本。

### 5. 验证

运行一次快速测试：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

应当以退出码 2 结束，并向 stderr 打印 BLOCKED 消息。
