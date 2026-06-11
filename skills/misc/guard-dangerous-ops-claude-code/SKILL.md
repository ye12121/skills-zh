---
name: guard-dangerous-ops-claude-code
description: 为 Claude Code 配置 PreToolUse 钩子，在执行前拦截不可逆的危险 Bash 操作——极端致命的（rm -rf /、写块设备、mkfs）直接拒绝；危险但常见的（rm -rf 某目录、find -delete、sudo、kill -9、npm publish、curl|sh 等）弹出确认，让用户 double check 后才放行；普通单文件删除和 /tmp 操作默认放行。git 破坏性命令不在此列（交给 git-guardrails-claude-code）。当用户希望阻止 agent 自动执行删除等危险/不可逆操作、添加危险操作护栏、或要求危险命令先确认再执行时使用。 / Set up a Claude Code PreToolUse hook that intercepts irreversible dangerous Bash operations before they run. Catastrophic ones (rm -rf /, writing to block devices, mkfs) are denied outright; dangerous-but-common ones (rm -rf a dir, find -delete, sudo, kill -9, npm publish, curl|sh, etc.) prompt the user to double-check before proceeding; plain single-file deletes and /tmp operations pass through. Git destructive commands are out of scope (use git-guardrails-claude-code). Use when the user wants to stop the agent from auto-running deletions or other dangerous/irreversible operations, add dangerous-op guardrails, or require dangerous commands to be confirmed first.
---

# 危险操作护栏

配置一个 PreToolUse 钩子，在 Claude 执行 Bash 命令前检查它，对不可逆的危险操作**拦截**。

## 为什么必须用钩子

skill 本身只是 agent 读的指令，只能「劝」agent——它会忘、会绕过。要做到「无论 agent 怎样都拦下」，唯一可靠的机制是 **PreToolUse 钩子**：Claude Code 在每次工具调用前强制运行它，与 agent 意愿无关。

## 两档行为

钩子用 JSON 输出 `permissionDecision`：

- **DENY（直接拒绝）** —— 极端致命、无正当理由：
  - `rm -rf` 目标为 `/`、`/*`、`~`、`$HOME`
  - 直写块设备（`dd … of=/dev/sd…`、`> /dev/disk…`）、`mkfs`、`shred … /dev/`
  - 对根 `/` 递归改权限/属主、fork 炸弹
- **ASK（弹确认，double check 后放行）** —— 危险但常见：
  - `rm -r` / `rm -f` / 带通配符的 `rm`、`find … -delete`、`find … -exec rm`
  - 递归 `chmod -R` / `chown -R`、删 `.env` / `.git` / `.ssh` / 密钥
  - `sudo`、`shutdown`/`reboot`、`kill -9`/`killall`/`pkill`
  - `npm/yarn/pnpm publish`、`gh repo delete`、`gh release delete`
  - `curl … | sh`、`apt remove/purge`、`brew uninstall`、`crontab -r`
- **放行** —— 普通单文件删除（`rm foo.txt`）、`/tmp` 与 `$TMPDIR` 下的操作，以及其余一切。

> 范围：不含 git（交给 [git-guardrails-claude-code](../git-guardrails-claude-code/SKILL.md)）、不含数据库/云资源（脚本末尾有注释模板，需要时取消注释即可加 ASK 规则）。
> 局限：匹配是「尽力而为」，防的是手滑而非蓄意对抗——别名、变量、`eval`、base64、管道拼接都可能绕过。钩子自身出错时一律**放行**（fail-open），避免把 agent 卡死。

## 安装步骤

依赖 `jq`（解析钩子输入）。脚本随附于 [scripts/block-dangerous-ops.sh](scripts/block-dangerous-ops.sh)。

### 1. 询问范围

问用户：仅当前**项目**（`.claude/`）还是**所有项目**（`~/.claude/`）？

### 2. 复制钩子脚本

- **项目级**：`.claude/hooks/block-dangerous-ops.sh`
- **全局**：`~/.claude/hooks/block-dangerous-ops.sh`

复制后 `chmod +x` 赋可执行权限。

### 3. 在 settings 中注册

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
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-ops.sh"
          }
        ]
      }
    ]
  }
}
```

**全局**（`~/.claude/settings.json`）：把 `command` 换成 `~/.claude/hooks/block-dangerous-ops.sh`。

> 已有 `hooks.PreToolUse`（比如装过 git-guardrails）时**不要覆盖**——把本钩子作为同一个 `Bash` matcher 下 `hooks` 数组里**新增的一项**，两个钩子会依次运行、互不影响。

### 4. 询问是否定制

问用户要不要增删 DENY / ASK 模式，或打开末尾的数据库/云规则，相应编辑脚本。

### 5. 验证

```bash
S=<脚本路径>
# 应 deny
echo '{"tool_input":{"command":"rm -rf /"}}'        | "$S"   # → permissionDecision":"deny"
# 应 ask
echo '{"tool_input":{"command":"rm -rf build"}}'    | "$S"   # → permissionDecision":"ask"
# 应放行（无输出）
echo '{"tool_input":{"command":"rm foo.txt"}}'      | "$S"   # → 空
```

## 相关

- [git-guardrails-claude-code](../git-guardrails-claude-code/SKILL.md) —— 同款机制专拦危险 **git** 命令；与本 skill 互补，可并存。
- [limit-commit-size](../limit-commit-size/SKILL.md) —— 用 git 钩子限制每次提交/推送的改动行数。
