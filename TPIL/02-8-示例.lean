/-
  第 2 章 · 第 8 课：命名空间（`namespace`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-8-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-8-示例.lean
-/

/-! ## 1. 问题：同一个名字不能定义两次

    `def v : Nat := 1` 之后再写 `def v : Nat := 2`，Lean 会报
    `error: `v` has already been declared`。
    （本文件要求零 error，所以那段**故意不写出来**；你可以在习题里自己试。）
    `namespace` 就是为「我还想再用这个名字」准备的。 -/

/-! ## 2. `namespace`：给名字加前缀 -/

namespace Box1
  def a : Nat := 5
  def f (x : Nat) : Nat := x + 7

  #check a        -- Box1.a : Nat            ← 在盒子里，打印的**也是全名**
  #check f        -- Box1.f (x : Nat) : Nat
end Box1

#check Box1.a     -- Box1.a : Nat
#check Box1.f     -- Box1.f (x : Nat) : Nat
#eval Box1.f 3    -- 10

-- ⚠️ `end Box1` 之后短名就没了。下面这行**取消注释会报错**，那是预期的：
-- #check a

/-! ## 3. `open`：把短名字拿出来用 -/

namespace Box2
  def b : Nat := 5
end Box2

open Box2

#check b          -- Box2.b : Nat   ← 注意：打印的**仍然是全名**
#check Box2.b     -- Box2.b : Nat   ← 全名照样能用（open 并没有改名字）

/-! 顺带一个现象：`open` 之后，`#print` 的**定义体**会显示成短名（名字本身没变）。 -/

namespace Box3
  def p : Nat := 5
  def g (x : Nat) : Nat := x + 7
  def gp : Nat := g p
end Box3

#print Box3.gp
-- def Box3.gp : Nat :=
-- Box3.g Box3.p

open Box3
#print Box3.gp
-- def Box3.gp : Nat :=
-- g p

/-! ## 4. 嵌套 namespace；关掉可以重开 -/

namespace Out1
  def a : Nat := 5
  def f (x : Nat) : Nat := x + 7
  def fa : Nat := f a

  namespace In1
    def ffa : Nat := f (f a)      -- 外层（Out1）的 f、a 可以直接用短名
    #check fa                      -- Out1.fa : Nat
    #check ffa                     -- Out1.In1.ffa : Nat
  end In1

  #check fa                        -- Out1.fa : Nat
  #check In1.ffa                   -- Out1.In1.ffa : Nat
end Out1

#check Out1.fa                     -- Out1.fa : Nat
#check Out1.In1.ffa                -- Out1.In1.ffa : Nat

open Out1
#check fa                          -- Out1.fa : Nat
#check In1.ffa                     -- Out1.In1.ffa : Nat

-- ⚠️ 关掉的 namespace **可以重开**，重开后算同一个盒子：
namespace Box4
  def a : Nat := 5
end Box4

namespace Box4
  def ffa : Nat := a + a          -- 第二段里能直接用短名 a
  #check ffa                       -- Box4.ffa : Nat
end Box4

#check Box4.ffa                    -- Box4.ffa : Nat

-- ⚠️ 嵌套必须**按开的顺序关**（先 `end Inner`、再 `end Outer`）。
--    写反了会报 `Invalid name after `end`: Expected …`（习题里可以自己试）。

/-! ## 5. `namespace` 像 `section` 的地方 -/

-- ① namespace 里的 `variable`，作用范围只到 namespace 结束
namespace VarBox
  variable (n : Nat)
  def doubleN := n + n
end VarBox

#check VarBox.doubleN              -- VarBox.doubleN (n : Nat) : Nat
#eval VarBox.doubleN 4             -- 8
-- ⚠️ 出了 namespace，短名 n 就没了（`#check n` 会报 Unknown identifier）

-- ② namespace 里的 `open`，关闭之后失效
namespace Tool2
  def h : Nat := 1
end Tool2

namespace UseBox
  open Tool2
  def useIt : Nat := h + 1
  #check useIt                     -- UseBox.useIt : Nat
end UseBox

#check UseBox.useIt                -- UseBox.useIt : Nat
-- ⚠️ 出了 UseBox，短名 h 就没了（`#check h` 会报 Unknown identifier）

/-! ## 6. 标准库的例子：`List`

    标准库把列表相关的东西都放进 `List`，所以它们的全名是 `List.nil` / `List.map` 这种。
    ⚠️ 输出里的 `{α : Type u}`（隐式参数）归 **2-10**、那个 `u`（宇宙）还没有归属的课——
    **本课只看名字那部分**。 -/

#check List.nil
#check List.map

open List
#check nil                         -- 短名可用
#check List.map                    -- 全名照样可用

/-! ## 7. 本课不引入的东西

    · `set_option`（属第 6 章）
    · `open` 的进阶写法（`open Foo in …` 之类）
    · 隐式参数 `{α : Type}`（归 2-10）与宇宙多态（待安排） -/
