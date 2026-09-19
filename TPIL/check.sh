#!/usr/bin/env bash
#
#  一次检查某一课的所有 .lean 文件
#
#  用法（在项目根目录）：
#      bash TPIL/check.sh 02-2
#
#  它会自动：
#    · 找出 TPIL/<课号>-*.lean
#    · 逐个用 Lean 检查并显示输出
#    · 对「示例」文件：要求零警告零错误
#    · 对「习题」文件：报告是否还有 sorry 占位，并给出验收结论
#
#  为什么要有这个脚本：课号是纯 ASCII（如 02-2），
#  而文件名含中文，手敲容易错位。用它就不必碰中文文件名。
#
set -u

# elan 的工具链（交互终端通常已配好，这里兜底）
export PATH="$HOME/.elan/bin:$PATH"

# 无论从哪里调用，都切到项目根目录（本脚本在 TPIL/ 下）
cd "$(dirname "$0")/.." || exit 1

# 列出已有的课号
list_lessons() {
  ls TPIL/ 2>/dev/null | grep -oE '^[0-9]+-[0-9]+' | sort -u | sed 's/^/    /'
}

if [ $# -lt 1 ]; then
  echo "用法: bash TPIL/check.sh <课号>"
  echo "例:   bash TPIL/check.sh 02-2"
  echo
  echo "现有的课号："
  list_lessons
  exit 2
fi

lesson="$1"
files=$(ls TPIL/"$lesson"-*.lean 2>/dev/null)

if [ -z "$files" ]; then
  echo "找不到文件：TPIL/$lesson-*.lean"
  echo
  echo "现有的课号："
  list_lessons
  exit 2
fi

problem=0

for f in $files; do
  echo "════════════════════════════════════════"
  echo "  $f"
  echo "════════════════════════════════════════"

  out=$(lake env lean "$f" 2>&1)
  rc=$?
  # 只数「真正的诊断行」（形如 文件:行:列: warning/error:）。
  # ⚠️ 不能用 grep -c 'warning'：Lean 的提示文字里也含 “warning” 字样
  #    （如 “to silence this warning”），实测会把 1 条警告数成 2 条。
  nwarn=$(printf '%s\n' "$out" | grep -cE -e ':[0-9]+:[0-9]+: warning:' -e '^warning:' || true)
  nerr=$(printf '%s\n' "$out" | grep -cE -e ':[0-9]+:[0-9]+: error:' -e '^error:' || true)

  if [ -n "$out" ]; then
    printf '%s\n' "$out"
    echo
  fi

  echo "  退出码=$rc  警告=$nwarn  错误=$nerr"

  case "$f" in
    *习题*)
      # 退出码非 0 也算失败（双保险：万一有诊断行不带「文件:行:列:」前缀，nerr 会漏数）
      if [ "$nerr" -gt 0 ] || [ "$rc" -ne 0 ]; then
        echo "  ❌ 有编译错误，先修掉"
        problem=1
      else
        # 验收：整行就是 sorry 的占位还有几处
        ph=$(grep -cE '^[[:space:]]*sorry[[:space:]]*$' "$f" || true)
        if [ "$ph" -eq 0 ]; then
          echo "  ✅ 验收通过（无编译错误，且没有 sorry 占位）"
        else
          echo "  ⏳ 还没做完：还有 $ph 处 sorry 占位"
        fi
      fi
      ;;
    *)
      if [ "$rc" -eq 0 ] && [ "$nwarn" -eq 0 ] && [ "$nerr" -eq 0 ]; then
        echo "  ✅ 干净（零警告、零错误）"
      else
        echo "  ⚠️  这个文件本应零警告零错误"
        problem=1
      fi
      ;;
  esac
  echo
done

if [ "$problem" -eq 0 ]; then
  echo "检查完毕。"
else
  echo "有问题需要处理，见上面的 ❌ / ⚠️。"
fi
exit "$problem"
