/-
  第 2 章 · 第 6 课：局部定义（`let`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-6-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-6-示例.lean
-/

/-! ## 1. `let` 就是「在一个表达式内部临时起个名字」

    `let y := 2 + 2; y * y` 从头到尾是**一个**表达式：把 `y` 换成 `2 + 2`，
    整个表达式的值就是 `(2 + 2) * (2 + 2)`。 -/

#check let y := 2 + 2; y * y
-- 打印（两行）：
--   let y := 2 + 2;
--   y * y : Nat

#eval let y := 2 + 2; y * y       -- 16
#eval (2 + 2) * (2 + 2)           -- 16   ← 把 y 替换掉，得到的就是它

/-! ## 2. 在 `def` 里用 `let`：给中间结果起名字

    `;` 与换行两种写法，值是同一个。 -/

def twice_double (x : Nat) : Nat :=
  let y := x + x; y * y

#check twice_double     -- twice_double (x : Nat) : Nat
#eval twice_double 2    -- 16

def t (x : Nat) : Nat :=
  let y := x + x
  y * y

#eval t 2               -- 16   ← 与 `#eval twice_double 2` 相同，只是排版不同

/-! ## 3. 串联多个 `let`；名字撞车

    撞车的规则：**第二个 `let` 右边看旧名字，从它往后看新名字。** -/

#eval let y := 2 + 2; let z := y + y; z * z    -- 64
#eval let y := 1; let y := y + 10; y           -- 11   ← 右边那个 y 是前一个 y（1）

/-! ## 4. `#check` 看到 `let` 时显示成什么

    三条规律：名字保留、**右边不计算**、**手写的类型标注不显示**。 -/

#check let n : Nat := 5; n + 1
-- 打印（两行）：
--   let n := 5;
--   n + 1 : Nat
-- ⚠️ 我写的是 `let n : Nat := 5`，打印出来的 `: Nat` 不见了。

/-! ## 5. `let` 与 `fun` 的对比：`foo` 能通过

    `let a := Nat` 里，`a` 是 `Nat` 的**缩写**（替换），
    所以 `fun x : a => x + 2` 检查时等同于 `fun x : Nat => x + 2`。

    ⚠️ 把它改写成原文的 `bar` —— `(fun a => fun x : a => x + 2) Nat` —— **会报错**，
    因为那种写法里 `a` 是**变量**。报错原文与解释见讲义第 7 节
    （这里不放，免得本文件出现 error）。 -/

def foo := let a := Nat; fun x : a => x + 2

#check foo        -- foo (x : Nat) : Nat
#eval foo 3       -- 5

/-! ## 6. 本课不引入的东西（讲义第 8 节也标了）

    · `have` / `show` —— 属于第 3 章《命题与证明》
    · `let (a, b) := p; …`（用 `let` 拆元组）—— 涉及模式匹配，后面章节才讲 -/
