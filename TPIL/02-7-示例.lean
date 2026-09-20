/-
  第 2 章 · 第 7 课：变量与区段（`variable` / `section`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-7-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-7-示例.lean
-/

/-! ## 1. 问题：同一个参数写了两遍 -/

def doTwiceA (f : Nat → Nat) (x : Nat) : Nat := f (f x)
def doThriceA (f : Nat → Nat) (x : Nat) : Nat := f (f (f x))

#check doTwiceA     -- doTwiceA (f : Nat → Nat) (x : Nat) : Nat
#check doThriceA    -- doThriceA (f : Nat → Nat) (x : Nat) : Nat

/-! ## 2. `variable`：参数只声明一次，Lean 自动把它补进定义里 -/

variable (f : Nat → Nat) (x : Nat)

def doTwiceB := f (f x)
def doThriceB := f (f (f x))

#check doTwiceB     -- doTwiceB (f : Nat → Nat) (x : Nat) : Nat
#print doTwiceB
-- def doTwiceB : (Nat → Nat) → Nat → Nat :=
-- fun f x => f (f x)
#print doThriceB
-- def doThriceB : (Nat → Nat) → Nat → Nat :=
-- fun f x => f (f (f x))

-- 「不写参数」得到的 `fun`，与「手写 fun」的版本是同一个东西：
-- Lean 补参数 = 把定义变成函数；而造函数的语法就是 `fun`。两行 `#print` 完全一样。
def doTwiceC : (Nat → Nat) → Nat → Nat := fun f x => f (f x)

#print doTwiceB
-- def doTwiceB : (Nat → Nat) → Nat → Nat :=
-- fun f x => f (f x)
#print doTwiceC
-- def doTwiceC : (Nat → Nat) → Nat → Nat :=
-- fun f x => f (f x)

#eval doTwiceA (fun k => k + 1) 5     -- 7
#eval doTwiceB (fun k => k + 1) 5     -- 7   ← 与手写参数的版本结果相同

/-! ### ⚠️ 一个容易踩的坑

    你手写的类型永远是**右边表达式的类型**；`variable` 的参数是 Lean **另外加在最前面**的。
    所以下面这样写是对的（`: Nat` 是 `n2 + n2` 的类型）： -/

variable (n2 : Nat)

def goodB : Nat := n2 + n2

#print goodB
-- def goodB : Nat → Nat :=
-- fun n2 => n2 + n2

-- ⚠️ 而写成 `def badB : Nat → Nat := n2 + n2` 会报错（Type mismatch：
--    `n2 + n2` 的类型是 Nat，不是 Nat → Nat）。讲义 §4 末尾有完整报错原文。

/-! ## 3. Lean 只把「用到」的变量变成参数

    下面声明了 `b`，但 `incX` 里没用到它 → 参数里就不会有 `b`。
    ⚠️ 这里用到的 `x`，就是 **§2** 里 `variable (f : Nat → Nat) (x : Nat)` 声明的那个。 -/

variable (b : Bool)

def incX := x + 1

#print incX
-- def incX : Nat → Nat :=
-- fun x => x + 1

/-! ⚠️ 一个澄清：打印出来的那个 `fun` **不是 `variable` 带来的**。
    任何「带参数的定义」，`#print` 都会写成 `fun`。
    看这三行对照（**中间那个完全没用 `variable`**）： -/

def five : Nat := 5                    -- 没有参数
def incZ (x : Nat) : Nat := x + 1      -- 手写参数（这个 x 是 incZ 自己的）
def incFun : Nat → Nat := fun x => x + 1   -- 连 fun 也手写

#print five
-- def five : Nat :=
-- 5                 ← 没有参数 → 没有 fun
#print incZ
-- def incZ : Nat → Nat :=
-- fun x => x + 1    ← 手写参数 → 有 fun
-- 三种写法（`variable` 版 `incX`、手写参数版 `incZ`、手写 `fun` 版 `incFun`）的 `#print` 完全一样：
#print incX
-- def incX : Nat → Nat :=
-- fun x => x + 1    ← variable 补参数 → 与 incZ、incFun 一模一样
#print incFun
-- def incFun : Nat → Nat :=
-- fun x => x + 1    ← 手写 fun → 同样一模一样

/-! ## 4. `section`：限定变量的作用范围

    要看清**两件不同的事**：变量出了 section **失效**，
    但 section 里定义的 **`def` 照旧存在**（参数已经固化在它里面）。 -/

section mysection
  variable (m : Nat)
  def squareM := m * m
end mysection

#check squareM      -- squareM (m : Nat) : Nat
#print squareM
-- def squareM : Nat → Nat :=
-- fun m => m * m
#eval squareM 4     -- 16

-- ⚠️ 下面这行**取消注释会报错**（`m` 已经出了作用域），那是预期的：
-- #check m

/-! ## 5. 匿名 section 与嵌套 section -/

section
  variable (k : Nat)
  def cubeK := k * k * k
end

#print cubeK
-- def cubeK : Nat → Nat :=
-- fun k => k * k * k

section outer
  variable (p : Nat)
  def addP := p + 1
  section inner
    variable (q : Nat)
    def addPQ := p + q
  end inner
  def addP2 := p + 2
end outer

#print addPQ
-- def addPQ : Nat → Nat → Nat :=
-- fun p q => p + q
#print addP2
-- def addP2 : Nat → Nat :=
-- fun p => p + 2

/-! ## 6. 原书 2.6 的写法：变量也可以是「类型」

    `α : Type` 就是「`α` 是一个类型」——这一点你在 **02-3** 学过。

    ⚠️ 本课只要求你**读懂、照用**。至于「为什么后面的参数可以依赖前面的参数」
    （`g : β → γ` 里的 `β`、`γ` 本身就是参数），那属于**依赖函数类型**，
    原理归 **2-9**（讲义第 7 节有范围说明）。 -/

variable (α β γ : Type)
variable (g : β → γ) (h : α → β) (z : α)

def composeB := g (h z)

#print composeB
-- def composeB : (α β γ : Type) → (β → γ) → (α → β) → α → γ :=
-- fun α β γ g h z => g (h z)

/-! ## 7. 本课不引入的东西

    · 隐式参数 `{α : Type}`（花括号）—— 原文 2.9 才讲
    · 依赖函数类型的原理 —— 归 2-9 -/
