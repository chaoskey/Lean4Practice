/-
  第 2 章 · 第 4 课 · 习题：函数抽象与求值（`fun`、应用、`#eval`）

  规则：
    · 前三题：把 `sorry` 换成你的定义（**这一课开始，你要自己造函数了**）
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-4-习题.lean

  ⚠️ 前三题请用 `fun` 写（这一课学的就是它）。不要用别的手段绕。
  ⚠️ `def` 本身的细节是下一课（2-5）的主题，本课不考。

  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、用 `fun` 写定义（把 sorry 换掉）============ -/

/-- 题 1：声明常量 `addThree`，类型 `Nat → Nat`，让它表示「把一个自然数**加三**」。
    请用 `fun` 写。 -/
def addThree : Nat → Nat :=
  sorry

/-- 题 2：声明常量 `mul`，类型 `Nat → Nat → Nat`，让它表示「两个自然数**相乘**」。
    提示：吃两个参数，`fun` 有两种写法（讲义第 5 节），随便挑一种。 -/
def mul : Nat → Nat → Nat :=
  sorry

/-- 题 3：声明常量 `compose`，类型 `(Nat → Nat) → (Nat → Nat) → Nat → Nat`，
    让它表示「把两个函数**复合**起来」：先对 `x` 用 `f`，再对结果用 `g`。
    提示：讲义第 8 节有现成的写法可以照抄（把类型换成这里的即可）。 -/
def compose : (Nat → Nat) → (Nat → Nat) → Nat → Nat :=
  sorry


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：下面这一行会打印什么？（连 `: ...` 一起写）

      #check fun x : Nat => fun y : Nat => x + y

    我的答案： -/


/- 题 5：下面这一行会打印什么？

      #eval (fun x : Nat => x + 5) 10

    我的答案： -/


/- 题 6：下面两行的输出**一样吗**？先说结论，再说为什么。

      #check fun (x : Nat) (y : Nat) => x + y
      #check fun x y => x + y

    我的答案： -/


/- 题 7：下面两个表达式，是不是**同一个函数**？为什么？

      fun (a : Nat) (b : Nat) => a + b
      fun (u : Nat) (v : Nat) => u + v

    我的答案： -/


/- 题 8：下面这一行**能**打印出类型，但 Lean 还会**额外给你一条警告**。

      #check fun x : Nat => true

    问：① 它打印出的类型是什么？② 那条警告在说什么？③ 正确（无警告）的写法是什么？

    我的答案： -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，答案就直接印出来了。
-- ⚠️ 最后那行 `#eval addThree 5` 要等你把题 1 做完再取消注释——
--    `#eval` 不能对含 `sorry` 的东西求值（Lean 会直接报错）。

-- #check addThree
-- #check mul
-- #check compose
-- #check fun x : Nat => fun y : Nat => x + y
-- #eval (fun x : Nat => x + 5) 10
-- #check fun (x : Nat) (y : Nat) => x + y
-- #check fun x y => x + y
-- #check fun x : Nat => true
-- #check fun (_ : Nat) => true
-- #eval addThree 5
