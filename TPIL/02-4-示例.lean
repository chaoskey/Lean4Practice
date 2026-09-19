/-
  第 2 章 · 第 4 课：函数抽象与求值（`fun`、应用、`#eval`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-4-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-4-示例.lean
-/

/-! ## 1. 用 `fun` 从一个表达式造出一个函数

    `fun (x : Nat) => x + 5` 读作「吃一个 `Nat`、叫它 `x`，吐回 `x + 5`」。
    `=>` 直接打 `=>` 即可（也可以打 `\=>`）。 -/

#check fun (x : Nat) => x + 5      -- fun x => x + 5 : Nat → Nat

/-! ## 2. `λ` 与 `fun` 完全同义

    `λ` 打 `\lambda`（或 `\la`）。Lean 把两者显示成同一个样子。 -/

#check λ (x : Nat) => x + 5       -- fun x => x + 5 : Nat → Nat   ← 和上一行输出完全相同

/-! ## 3. 类型标注可以省 —— 但不是总能省

    下面这行**没有**写 `: Nat`；不过 `+ 5` 里的 `5 : Nat` 给了足够线索，Lean 能推出来。
    （**推不出来的**情形见讲义第 4 节，以及习题题 6。） -/

#check fun x => x + 5             -- fun x => x + 5 : Nat → Nat

/-! ## 4. 多参数：两种写法，同一个类型

    · 嵌套写：`fun x : Nat => fun y : Nat => ...`
    · 一行写：`fun (x : Nat) (y : Nat) => ...`
    两者 Lean 都打印成 `fun x y => ...` —— 正呼应 02-2 第 5 节的「箭头右结合」。 -/

#check fun x : Nat => fun y : Nat => x + y   -- fun x y => x + y : Nat → Nat → Nat
#check fun (x : Nat) (y : Nat) => x + y      -- fun x y => x + y : Nat → Nat → Nat

/-! ## 5. 恒等函数与常函数

    ⚠️ 第 2 行故意写成 `(_ : Nat)` 而不是 `(x : Nat)`：
    `x` 在函数体里**根本没被用到**，Lean 会为此报警告；写成 `_` 就是告诉它「这个名字我不需要」。
    （另外注意：Lean **显示**时自己起了个名字 `x`——显示出来的名字不代表你起了名字。） -/

#check fun x : Nat => x           -- fun x => x : Nat → Nat
#check fun (_ : Nat) => true      -- fun x => true : Nat → Bool   ← 写 _ 才不会警告

/-! ## 6. 绑定变量的名字只是占位符（alpha 等价）

    下面两个表达式的**类型完全相同**（都是 `Nat → Nat → Nat`）；
    Lean 把它们当作**同一个函数**——「只换了参数名字」的两个表达式叫 alpha 等价。 -/

#check fun (a : Nat) (b : Nat) => a + b     -- fun a b => a + b : Nat → Nat → Nat
#check fun (u : Nat) (v : Nat) => u + v     -- fun u v => u + v : Nat → Nat → Nat

/-! ## 7. 应用：把一个函数用在一个东西上

    规则：`t : α → β` 且 `s : α`，则 `t s : β`。 -/

#check (fun x : Nat => x) 1       -- (fun x => x) 1 : Nat
#check (fun (_ : Nat) => true) 1  -- (fun x => true) 1 : Bool

/-! `#eval` 会真的把它**算出来**（这是测试函数最常用的办法）： -/

#eval (fun x : Nat => x + 5) 10   -- 15
#eval (fun x : Nat => x) 1        -- 1
#eval (fun (_ : Nat) => true) 1   -- true

/-! ## 8. 部分应用：只喂一部分参数

    这是 02-2 第 6 节讲过的同一件事——`Nat → Nat → Nat` 吃一个参数之后，剩下的**还是函数**。 -/

#check (fun x y : Nat => x + y) 3      -- (fun x y => x + y) 3 : Nat → Nat
#eval ((fun x y : Nat => x + y) 3) 4   -- 7

/-! ## 9. 函数也可以当参数（复合两个函数）

    `fun g f x => g (f x)` 读作：吃两个函数 `g`、`f` 和一个值 `x`，
    **先**对 `x` 用 `f`，**再**对结果用 `g`。 -/

#check fun (g : Nat → Nat) (f : Nat → Nat) (x : Nat) => g (f x)
-- fun g f x => g (f x) : (Nat → Nat) → (Nat → Nat) → Nat → Nat

#eval (fun (g : Nat → Nat) (f : Nat → Nat) (x : Nat) => g (f x))
        (fun n => n * 2) (fun n => n + 1) 3      -- 8   ← 先 +1 得 4，再 ×2 得 8

/-! ## 10. `fun` 与 `def` 的两种写法是同一件事

    上面那种 `def double2 (n : Nat) : Nat := ...`，意思就是
    `def double2 : Nat → Nat := fun n => ...`。
    （两者的**显示形式**不同——这正是 02-2 第 8 节讲过的望远镜式 / 箭头式。） -/

def double1 : Nat → Nat := fun n => n * 2
def double2 (n : Nat) : Nat := n * 2

#check double1                    -- double1 : Nat → Nat
#check double2                    -- double2 (n : Nat) : Nat
#eval double1 5                   -- 10
#eval double2 5                   -- 10

/-! ## 11. 绑定变量的作用域：里面的 `seven` 与外层的 `seven` 无关 -/

def seven : Nat := 7

#eval (fun seven : Nat => seven + 1) 10   -- 11   ← 用的是参数 10，不是外层的 7
