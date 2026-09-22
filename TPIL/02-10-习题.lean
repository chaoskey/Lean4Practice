/-
  第 2 章 · 第 10 课 · 习题：隐式参数（implicit arguments）

  规则：
    · 前三题：按题面把定义改成「隐式参数」版（并把 `sorry` 换掉）
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-10-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）：
     题 2 要求你**改一行 `variable`**，而 `/-- … -/` 是文档注释、必须紧贴声明，中间插东西会报错。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、按题面改成「隐式参数」版 ============ -/

/- 题 1：下面 `identEx` 的 `α` 是**显式**参数（圆括号）——所以调用时必须写成 `identEx Nat 7`。
    请改成「**调用时不用写 `α`**」的形式（见讲义 §4），**并补完定义体**（返回 `x`）。 -/
def identEx {α : Type} (x : α) : α :=
  x

/- 题 2：下面这行 `variable` 声明的 `α` 也是**显式**的。
    请把它改成「**调用时不用写 `α`**」的形式（见讲义 §5），**并补完定义体**（返回 `x`）。
    （改的是那一行 `variable`，别动 `def` 的参数表。） -/
variable {α : Type}

def constEx (x : α) : α :=
  x

/- 题 3：让 `sevenViaAt` 等于「把 `identEx` 用在 `7` 上」的结果。
    约束：**必须用 `@` 显式地把类型参数 `Nat` 传进去**（见讲义 §7）——
    也就是**不要**写成平时那种省略类型参数的样子。 -/
def sevenViaAt : Nat :=
  @identEx Nat 7


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`#check (identEx)` 会打印出什么？
    为什么里面会出现 `?m.1` 这种带问号的东西？

    我的答案： identEx : ?m.1 → ?m.1。 难道是因为 α 是隐式参数而且这里没给它任何线索，所以 Lean 会生成一个带问号的元变量 ?m.1 来表示它？ -/


/- 题 5：`#check identEx` 与 `#check @identEx` 打印的东西**有什么区别**？
    （提示：花括号还在不在？参数要不要写？）

    我的答案： 前者 望远镜式：identEx {α : Type} (x : α) : α ，而后者 箭头式：@identEx : {α : Type} → α → α。 -/


/- 题 6：`#check (List.nil)` 与 `#check (List.nil : List Nat)` 分别打印什么？
    为什么第二个要写成 `(List.nil : List Nat)` 这种带类型标注的样子？

    我的答案： 前者打印 [] : List ?m.1 ， 后者打印 [] : List Nat 。 因为 给一个类型 → Lean 据此把隐式参数填上。 -/


/- 题 7：`#check 2`、`#check (2 : Nat)`、`#check (2 : Int)` 分别打印什么？
    如果 Lean **推不出**一个数字的类型，它默认当成什么？

    我的答案：第一个打印 2 : Nat , 第二个打印 2 : Nat , 第三个打印 2 : Int 。 如果 Lean 推不出一个数字的类型，它默认当成 Nat。 -/


/- 题 8：用**一句话**说明：什么是「隐式参数」？
    并且说清 **`_`（下划线）** 和 **`{}`（花括号）** 各自起什么作用。

    我的答案：所谓隐式参数，就是可以让系统自动推断出来的参数。下划线可以理解成 让 Lean 自己填的洞。花括号调用时默认不用写，但可以由系统自动推断出来。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 带 `#eval` 的那一行要等你把题 3 做完再取消注释
--    （`#eval` 不能对含 `sorry` 的东西求值）。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#check identEx  -- identEx {α : Type} (x : α) : α
#check @identEx  -- @identEx : {α : Type} → α → α
#check (identEx)  -- identEx : ?m.1 → ?m.1
#check (identEx : Nat → Nat)  -- identEx : Nat → Nat

#check constEx  -- constEx {α : Type} (x : α) : α
#check constEx 4  -- constEx 4 : Nat
#check constEx true  -- constEx true : Bool

#eval sevenViaAt -- 7

-- 额外核对（讲义 §6 / §7 那两个现象）：
#check (List.nil)  -- [] : List ?m.1
#check (List.nil : List Nat)  -- [] : List Nat
#check 2  -- 2 : Nat
#check (2 : Int)  -- 2 : Int
