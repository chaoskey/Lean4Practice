/-
  第 3 章 · 第 3 课：合取 `∧`
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `03-3-习题.lean`。

  检查本文件：
    lake env lean TPIL/03-3-示例.lean
-/

section
  variable (p q r : Prop)

/-! ## 1. 打包：`And.intro` 与 `⟨,⟩` -/

-- 结果类型已知（`: p ∧ q` 写在冒号后面）→ 两种写法都行
example (hp : p) (hq : q) : p ∧ q := And.intro hp hq
example (hp : p) (hq : q) : p ∧ q := ⟨hp, hq⟩

#check And.intro
-- And.intro {a b : Prop} (left : a) (right : b) : a ∧ b

-- Lean 打印时偏爱匿名构造子：下面这行打出来是 `fun hp hq => ⟨hp, hq⟩`
#check (fun (hp : p) (hq : q) => And.intro hp hq)

/-! ## 2. `And` 的内部结构（`#print`） -/

#print And
-- structure And (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   And.left : a
--   And.right : b
-- constructor:
--   And.intro {a b : Prop} (left : a) (right : b) : a ∧ b

/-! ## 3. 拆包：`And.left` / `And.right`（以及 `.left` / `.right` / `.1` / `.2`） -/

#check And.left
-- And.left {a b : Prop} (self : a ∧ b) : a
#check And.right
-- And.right {a b : Prop} (self : a ∧ b) : b

-- 四种拆法，造出的函数类型完全一样
example (h : p ∧ q) : p := And.left h
example (h : p ∧ q) : p := h.left
example (h : p ∧ q) : p := h.1
example (h : p ∧ q) : q := And.right h
example (h : p ∧ q) : q := h.right
example (h : p ∧ q) : q := h.2

#check (fun (h : p ∧ q) => h.left)
-- fun h => h.left : p ∧ q → p

-- 嵌套的合取：从右边一层层拆
example (h : p ∧ (q ∧ r)) : r := h.right.right

/-! ## 4. 交换：`p ∧ q → q ∧ p`（原文的例子） -/

example (h : p ∧ q) : q ∧ p := And.intro (And.right h) (And.left h)

-- 同一件事，用点记号 + 匿名构造子写
example (h : p ∧ q) : q ∧ p := ⟨h.right, h.left⟩

#check ((fun (h : p ∧ q) => ⟨h.right, h.left⟩) : p ∧ q → q ∧ p)
-- fun h => ⟨h.right, h.left⟩ : p ∧ q → q ∧ p

/-! ## 5. 嵌套的「扁平化」（只对右嵌套成立） -/

-- 下面两个证明说的是同一件事：`q ∧ p ∧ q` 按右结合 = `q ∧ (p ∧ q)`
example (h : p ∧ q) : q ∧ p ∧ q := ⟨h.right, ⟨h.left, h.right⟩⟩
example (h : p ∧ q) : q ∧ p ∧ q := ⟨h.right, h.left, h.right⟩

-- 左嵌套就必须显式嵌一层（`(p ∧ q) ∧ r`）
example (hp : p) (hq : q) (hr : r) : (p ∧ q) ∧ r := ⟨⟨hp, hq⟩, hr⟩

/-! ## 6. `∧` 与 `×`：形状一样，但一个住 `Prop`、一个住 `Type` -/

#check (And p q)          -- p ∧ q : Prop
#check (Prod Nat Nat)     -- Nat × Nat : Type
#check (Prod.mk 1 true)   -- (1, true) : Nat × Bool

-- ⚠️ 反过来混用会报错（故意不写在这里，免得文件变红）：
--     #check And Nat Nat   → error: ... has type Type ... but is expected to have type Prop
--     #check Prod p q      → error: ... has type Prop ... but is expected to have type Type ?u

/-! ## 7. 点记号 `e.bar` = `Foo.bar e` -/

-- ⚠️ `List` 是 Lean 内置的列表类型，它的定义属第 7 章，本课不必理解；
--     这里只把它当成「有一个 `length` 函数的类型」来演示点记号。
variable (xs : List Nat)

#check List.length xs   -- xs.length : Nat
#check xs.length        -- xs.length : Nat

-- 不用 `List` 的同类例子
#check (3 : Nat).succ   -- Nat.succ 3 : Nat

/-! ## 8. `example` 与 `theorem` -/

example : p → p := fun hp => hp        -- 通过；没有名字，之后无从引用

theorem demo_named : p → p := fun hp => hp
#check demo_named
-- demo_named (p : Prop) : p → p

end

/-! ## 9. 本课不引入的东西

    · tactic（`constructor` / `cases` / `by` / `apply`…）—— 第 5 章；原文 3.3.1 用的是证明项
    · `Or`（`∨`）—— 3-4
    · `Not`（`¬`）/ `False` —— 3-5
    · `Iff`（`↔`）—— 3-6
    · `structure` / 「归纳类型」/ `List` 的定义 —— 第 7 章 -/
