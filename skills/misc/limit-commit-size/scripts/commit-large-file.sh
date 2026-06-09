#!/bin/sh
# 把一个「单次新增就超限」的大文件，分成多个 < LIMIT 行的提交落地。
#
# 为什么需要它：对全新（未跟踪）文件，`git add -p` 无法分块——它要么报
# "No changes"，要么在 `git add -N` 后把整个文件当成一个无法 split 的 hunk。
# 本脚本用 `git apply --cached` 按行范围分块暂存：
#   • 不会把文件拆成多个文件
#   • 不修改工作区内容（工作区始终是完整文件）
#   • 最终提交的内容与工作区逐字节一致，只是历史上分了几个提交
#
# 用法：commit-large-file.sh <file> [limit]
#   limit 默认 1000；脚本会留 10% 余量（如 limit=1000 -> 每块 ~900 行）。
set -e

file="$1"
limit="${2:-1000}"
[ -n "$file" ] || { echo "用法: $0 <file> [limit]"; exit 2; }
[ -f "$file" ] || { echo "文件不存在: $file"; exit 2; }

chunk=$(( limit - limit / 10 ))
# 用 awk 数行：能把「结尾没有换行符的最后一行」也算进去（wc -l 会漏掉它）。
total=$(awk 'END{print NR}' "$file")
[ "$total" -gt 0 ] || { echo "空文件，直接 git add 即可"; exit 1; }

# 文件结尾是否缺换行符：缺的话最后一块补丁要带 “\ No newline at end of file”，
# 否则最终内容会比原文件多一个换行，破坏逐字节一致。
no_eol=0
[ -n "$(tail -c1 "$file")" ] && no_eol=1

committed=0
while [ "$committed" -lt "$total" ]; do
  target=$(( committed + chunk ))
  [ "$target" -gt "$total" ] && target="$total"
  add=$(( target - committed ))
  patch=$(mktemp)
  if [ "$committed" -eq 0 ]; then
    printf 'diff --git a/%s b/%s\nnew file mode 100644\n--- /dev/null\n+++ b/%s\n@@ -0,0 +1,%d @@\n' \
      "$file" "$file" "$file" "$add" > "$patch"
  else
    printf 'diff --git a/%s b/%s\n--- a/%s\n+++ b/%s\n@@ -%d,0 +%d,%d @@\n' \
      "$file" "$file" "$file" "$file" "$committed" "$((committed + 1))" "$add" > "$patch"
  fi
  awk -v s="$((committed + 1))" -v e="$target" 'NR>=s && NR<=e {print "+"$0}' "$file" >> "$patch"
  # 只有「最后一块」且原文件结尾无换行符时，才追加 no-newline 标记。
  [ "$target" -eq "$total" ] && [ "$no_eol" -eq 1 ] && printf '\\ No newline at end of file\n' >> "$patch"
  git apply --cached "$patch"
  rm -f "$patch"
  git commit -q -m "$file: 第 $((committed + 1))-$target 行 / 共 $total 行"
  echo "  ✓ 已提交 第 $((committed + 1))-$target 行 (+$add)"
  committed="$target"
done

echo "完成：$file 共 $total 行，已分多次提交，工作区文件保持完整。"
