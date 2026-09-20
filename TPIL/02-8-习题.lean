/-
  第 2 章 · 第 8 课 · 习题：命名空间（`namespace`）

  规则：
    · 前三题：按题面补上 `namespace` / `end` / `open` 行，并把 `sorry` 换成你的定义
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-8-习题.lean

  ⚠️ 本课的题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）：
     因为你要在「注释」和「定义」之间插 `namespace` / `open` 行，
     而 `/-- … -/` 是**文档注释**，它必须**紧贴**一个声明，中间插东西会报错。
     （上一课 `02-7` 就是栽在这一点上——讲义 §3 有说明。）
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、按题面写 `namespace` / `end` / `open` ============ -/

/- 题 1：让下面这个定义做完之后，它的**全名**是 `MyBox.five`（值用 `5`）。 -/
namespace MyBox
  def five : Nat :=
    5
end MyBox

/- 题 2：让下面这个定义做完之后，它的**全名**是 `Outer.Inner.seven`（值用 `7`）。
    ⚠️ 注意关的顺序。 -/
namespace Outer
  namespace Inner
    def seven : Nat :=
      7
  end Inner
end Outer

/- 题 3：让下面这个定义里**只用短名** `inc` 就能调用到 `Tool` 里的那个函数
    （也就是把右边写成 `inc 5`，**不要**写 `Tool.inc 5`）。 -/
namespace Tool
  def inc (n : Nat) : Nat := n + 1
end Tool
open Tool
def useInc : Nat :=
  inc 5


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：在 `namespace Foo` **里面**写 `#check a`（`a` 是在 `Foo` 里定义的），
    它会打印成 `a : Nat` 还是 `Foo.a : Nat`？

    我的答案：是后者 -/


/- 题 5：`end Foo` **之后**，下面两行分别行不行？
      ① `#check a`（短名）
      ② `#check Foo.a`（全名）

    我的答案：第一个不可以，第二个可以。 -/


/- 题 6：`section` 与 `namespace` 有一个**关键区别**：哪一个**可以不起名字**？
    （两者都必须在 `end` 处结束，而且嵌套时都要按开的顺序关——这两点是一样的。）

    我的答案：第一个可以不用取名字，第二个必须要取名字。 -/


/- 题 7：嵌套的两个命名空间，能**乱序**关吗？例如先开 `Outer`、再开 `Inner`，
    然后写成 `end Outer`、再 `end Inner`——行不行？为什么？

    我的答案：在嵌套中肯定是不可以的，先开的要后关。 -/


/- 题 8：写了 `open Foo` 之后，全名 `Foo.a` **还能不能用**？
    （提示：`open` 到底是「把名字改短了」，还是「让你多一个短名字可用」？）

    我的答案：可以，短名字和长名字都能用。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 带 `#eval` 的那几行要等你把前三题做完再取消注释
--    （`#eval` 不能对含 `sorry` 的东西求值）。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#check MyBox.five   -- MyBox.five : Nat
#eval MyBox.five  -- 5

#check Outer.Inner.seven  -- Outer.Inner.seven : Nat
#eval Outer.Inner.seven  -- 7

#check useInc  -- useInc : Nat
#eval useInc  --6

-- 题 4 的核对（注意：这次是在 `Foo` 的**里面**看 `a`）：
namespace Foo
  def a : Nat := 5
  #check a   -- Foo.a : Nat
end Foo

-- 题 5 的核对：
-- #check a        ← ⚠️ 取消注释会报错，那是预期的
#check Foo.a  --  Foo.a : Nat
