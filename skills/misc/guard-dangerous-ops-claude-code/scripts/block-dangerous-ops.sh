#!/bin/bash
# Claude Code PreToolUse 钩子：拦截不可逆的危险 Bash 操作。
#
# 两档处理（用 JSON 输出 + exit 0，符合官方推荐）：
#   • DENY —— 极端致命、无正当理由（rm -rf /、写块设备、mkfs…）→ 直接拒绝。
#   • ASK  —— 危险但常见（rm -rf <某目录>、sudo、publish…）→ 弹确认，用户放行才执行。
# 其余一律放行（落入正常权限流）。
#
# 不处理 git 破坏性命令——那交给 git-guardrails-claude-code。
# 不处理数据库 / 云资源（v1 范围外，可在下方按注释自行加 ASK 规则）。
#
# 匹配是「尽力而为」：防的是顺手就执行的手滑，不是蓄意对抗。
# 别名、变量、eval、base64、管道拼接都可能绕过。任何内部错误都「放行」
# （fail-open），避免钩子自身故障把 agent 卡死。

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$CMD" ] && exit 0

deny() {
  jq -nc --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}' \
    2>/dev/null || exit 0
  exit 0
}
ask() {
  jq -nc --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}' \
    2>/dev/null || exit 0
  exit 0
}
match() { printf '%s' "$CMD" | grep -Eq "$1"; }

# 危险根/家目标（rm 的删除目标恰为 / /* ~ ~/ $HOME 时才算「灾难级」；
# 像 /home/x/proj 这种具体路径不算，留给 ASK 档）
ROOT='[[:space:]](/|/\*|~|~/?|\$HOME/?)([[:space:]]|;|\||&|$)'
# rm 的递归 / 强制 标志（兼容 -rf、-fr、-r -f、--recursive、--force）
RECUR='([[:space:]]-[[:alnum:]]*[rR][[:alnum:]]*([[:space:]]|;|\||&|$)|--recursive)'
FORCE='([[:space:]]-[[:alnum:]]*[fF][[:alnum:]]*([[:space:]]|;|\||&|$)|--force)'

# ===================== 第一档：DENY（致命） =====================
# rm 递归 且 强制，且目标是根 / 家目录
if match '(^|[^[:alnum:]_./-])rm[[:space:]]' && match "$RECUR" && match "$FORCE" && match "$ROOT"; then
  deny "rm 递归强制删除根/家目录（/、~、\$HOME 等），会造成灾难性、不可恢复的数据丢失。如确需，请人工手动执行。"
fi
# 直写块设备 / 格式化 / 抹除设备
match 'dd[[:space:]].*[[:space:]]of=/dev/(sd|disk|nvme|hd|vd|mmcblk)' && deny "dd 直写块设备会摧毁整块磁盘的数据。"
match '>[[:space:]]*/dev/(sd|disk|nvme|hd|vd|mmcblk)'                 && deny "重定向写入块设备会摧毁磁盘数据。"
match '(^|[^[:alnum:]_./-])mkfs([[:space:]._]|$)'                     && deny "mkfs 会格式化文件系统，原有数据全失。"
match '(^|[^[:alnum:]_./-])shred[[:space:]].*/dev/'                   && deny "shred 抹除块设备不可恢复。"
# 对根递归改权限 / 属主
match '(chmod|chown)[[:space:]].*(-[[:alnum:]]*R|--recursive).*[[:space:]]/([[:space:]]|;|\||&|$)' \
  && deny "对根目录 / 递归修改权限或属主会破坏整个系统。"
# fork 炸弹
match ':[[:space:]]*\([[:space:]]*\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:' \
  && deny "fork 炸弹会耗尽系统资源、使机器失去响应。"

# ============ 白名单：明显安全 → 放行（不打扰） ============
# rm 只动 /tmp、/var/tmp、$TMPDIR，且不含危险根目标
if match '(^|[^[:alnum:]_./-])rm[[:space:]]' && match '(/tmp/|/var/tmp/|\$TMPDIR|\$\{TMPDIR)' && ! match "$ROOT"; then
  exit 0
fi

# ===================== 第二档：ASK（确认后放行） =====================
# 删除：递归 / 强制 / 通配符 的 rm（普通单文件 rm 不在此列 → 放行）
if match '(^|[^[:alnum:]_./-])rm[[:space:]]'; then
  if match "$RECUR" || match "$FORCE" || match 'rm[[:space:]][^|;&]*[*?]'; then
    ask "rm 递归/强制/通配删除，可能不可逆地删掉文件。请 double check 目标无误再放行。"
  fi
fi
# find 批量删除
match 'find[[:space:]].*-delete'                && ask "find -delete 会批量删除所有匹配到的文件。"
match 'find[[:space:]].*-exec[[:space:]]+rm'    && ask "find -exec rm 会批量删除所有匹配到的文件。"
# 递归改权限 / 属主（非根）
match '(chmod|chown)[[:space:]].*(-[[:alnum:]]*R|--recursive)' && ask "递归修改权限/属主，可能影响大量文件。"
# 删除敏感 / 凭证 / 版本库文件
if match '(^|[^[:alnum:]_./-])rm[[:space:]]' && match '(\.env([[:space:].]|$)|/\.git([[:space:]/]|$)|\.ssh([[:space:]/]|$)|id_rsa|\.pem([[:space:]]|$)|credential)'; then
  ask "正在删除敏感/凭证或版本库文件（.env、.git、.ssh、密钥等）。请确认。"
fi
# 权限提升
match '(^|[^[:alnum:]_./-])sudo[[:space:]]' && ask "sudo 以管理员权限执行，影响面大且可能不可逆。"
# 关机 / 重启
match '(^|[^[:alnum:]_./-])(shutdown|reboot|halt|poweroff)([[:space:]]|$)' && ask "将关机或重启本机。"
# 强杀进程
match '(^|[^[:alnum:]_./-])kill[[:space:]]+-9'                    && ask "kill -9 强制杀进程，可能丢失未保存数据。"
match '(^|[^[:alnum:]_./-])(killall|pkill)[[:space:]]'           && ask "批量杀进程，可能波及预期外的进程。"
# 发布 / 删仓库 / 删 release（对外、难撤回）
match '(npm|yarn|pnpm)[[:space:]]+publish'      && ask "即将向 registry 发布包（对外公开、难以撤回）。"
match 'gh[[:space:]]+repo[[:space:]]+delete'    && ask "即将删除 GitHub 仓库（不可逆）。"
match 'gh[[:space:]]+release[[:space:]]+delete' && ask "即将删除 GitHub release。"
# 下载即执行远程脚本
match '(curl|wget)[[:space:]].*\|[[:space:]]*(sudo[[:space:]]+)?(sh|bash|zsh)([[:space:]]|$)' \
  && ask "下载并直接执行远程脚本（如 curl ... | sh），来源不可控、风险高。"
# 卸载 / 清理
match '(apt|apt-get)[[:space:]]+(remove|purge)' && ask "卸载系统软件包。"
match '(^|[^[:alnum:]_./-])brew[[:space:]]+uninstall'  && ask "卸载 Homebrew 软件包。"
match '(^|[^[:alnum:]_./-])crontab[[:space:]]+-r'      && ask "crontab -r 会清空当前用户的全部定时任务。"

# --- 想加数据库/云规则时，照下面格式追加 ASK（v1 默认关闭） ---
# match '(DROP|TRUNCATE)[[:space:]]+(TABLE|DATABASE)'   && ask "数据库 DROP/TRUNCATE 不可逆。"
# match 'terraform[[:space:]]+destroy'                  && ask "terraform destroy 会销毁基础设施。"
# match 'kubectl[[:space:]]+delete'                     && ask "kubectl delete 删除集群资源。"

exit 0
