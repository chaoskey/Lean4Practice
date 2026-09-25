/-
  第 3 章 · 第 6 课 · 示例：逻辑等价 `↔`

  本文件全部用**证明项**（原文 3.3.4 也是）；**零 warning**。
-/

variable (p q r : Prop)

/-! ## 1. `Iff` 长什么样（实测输出） -/

#check Iff
-- Iff (a b : Prop) : Prop
#print Iff
-- structure Iff (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   Iff.mp : a → b
--   Iff.mpr : b → a
-- constructor:
--   Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b
-- ⚠️ **只有 1 个构造子** → `⟨,⟩` 可用（同 `And`，不同 `Or`）

#check Iff.intro
-- Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b
#check Iff.mp
-- Iff.mp {a b : Prop} (self : a ↔ b) : a → b
#check Iff.mpr
-- Iff.mpr {a b : Prop} (self : a ↔ b) : b → a

/-! ## 2. 造一个 `p ↔ q`（原文例子：合取交换律） -/

theorem and_swap : p ∧ q ↔ q ∧ p :=
  Iff.intro
    (fun h : p ∧ q => show q ∧ p from And.intro (And.right h) (And.left h))
    (fun h : q ∧ p => show p ∧ q from And.intro (And.right h) (And.left h))

-- 同一个定理的简短写法
theorem and_swap' : p ∧ q ↔ q ∧ p :=
  ⟨ fun h => ⟨h.right, h.left⟩, fun h => ⟨h.right, h.left⟩ ⟩

/-! ## 3. 用它：取一个方向出来 -/

-- ① 点记号
example (h : p ∧ q) : q ∧ p := (and_swap p q).mp h
-- ② 全名调用
example (h : p ∧ q) : q ∧ p := Iff.mp (and_swap p q) h
-- ③ 反向
example (h : q ∧ p) : p ∧ q := (and_swap p q).mpr h
-- ④ 数字记号也可用（与点记号等价）
example (h : p ∧ q) : q ∧ p := (and_swap p q).1 h

/-! ## 4. ⚠️ `p ↔ q` **不是** `(p → q) ∧ (q → p)` 的别名 -/

-- ❌ 下面这句**不通过**（故意写错，所以**不加** ```lean 标记）：
--
-- example (h : p ↔ q) : (p → q) ∧ (q → p) := h
--   ↑ error: Type mismatch
--     h has type p ↔ q but is expected to have type (p → q) ∧ (q → p)

-- 要转换，得**显式造出来**（下面两条都实测通过）：
example (h : p ↔ q) : (p → q) ∧ (q → p) := ⟨h.mp, h.mpr⟩
example (h : (p → q) ∧ (q → p)) : p ↔ q := Iff.intro h.left h.right

-- 📌 对照 3-5：`¬p` 是 `def`，所以 `¬p` 与 `p → False` **按定义相等**；
--     `↔` 是 `structure`，所以**不能**直接顶替 `(p → q) ∧ (q → p)`。

/-! ## 5. ⚠️ 优先级与结合性（实测） -/

#check (p ↔ (q ↔ r))
-- p ↔ (q ↔ r) : Prop
#check ((p ↔ q) ↔ r)
-- (p ↔ q) ↔ r : Prop

-- ❌ `↔` **不能连写**（故意写错，所以**不加** ```lean 标记）：
--
-- #check (p ↔ q ↔ r)
--   ↑ error: unexpected token '↔'; expected ')', ','

#check (p ↔ q → r)
-- p ↔ q → r : Prop
-- ✅ 能通过说明它读作 `p ↔ (q → r)`；要表达 `p → (q ↔ r)` **必须自己加括号**。
#check (p → (q ↔ r))
-- p → (q ↔ r) : Prop

/-! ## 6. 一个自己造的等价：合取交换律的**自反方向**演示 -/

-- 从一个已经有的等价推出它的**对称**（对称性用 `.mpr` / `.mp`）
example (h : p ↔ q) : q ↔ p := ⟨h.mpr, h.mp⟩
