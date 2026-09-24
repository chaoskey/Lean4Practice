/-
  第 3 章 · 第 4 课 · 示例：析取 `∨`

  ⚠️ 提醒：第 5 行那句「`∧` 的匿名构造子 `⟨,⟩`」是**故意写错**的（对 `∨` 而言），
     它不能编译；所以这里**只**在注释里保留那个报错信息，**没有**把错误代码放进本文件。
-/

variable (p q : Prop)

/-! ## 1. 引入规则：任选一边造出 `p ∨ q` -/

-- 全名：要把「另一半是什么」明确写出来
example (hp : p) : p ∨ q := Or.intro_left q hp
example (hq : q) : p ∨ q := Or.intro_right p hq

-- 短写：另一半由 Lean 从「我要造的类型」推出来
example (hp : p) : p ∨ q := Or.inl hp
example (hq : q) : p ∨ q := Or.inr hq

/-! ## 2. 四个函数的类型（实测输出） -/

#check Or.inl
-- Or.inl {a b : Prop} (h : a) : a ∨ b
#check Or.inr
-- Or.inr {a b : Prop} (h : b) : a ∨ b
#check Or.intro_left
-- Or.intro_left {a : Prop} (b : Prop) (h : a) : a ∨ b
#check Or.intro_right
-- Or.intro_right {b : Prop} (a : Prop) (h : b) : a ∨ b

/-! ## 3. `Or` 有两个构造子，`And` 只有一个（对比 3-3） -/

#print Or
-- inductive Or : Prop → Prop → Prop
-- number of parameters: 2
-- constructors:
-- Or.inl : ∀ {a b : Prop}, a → a ∨ b
-- Or.inr : ∀ {a b : Prop}, b → a ∨ b

-- ⚠️ 正因为有**两个**构造子，匿名构造子 `⟨,⟩`（3-3 学的）在 `p ∨ q` 上**用不了**。
--    实测的报错原文是：
--      error: Invalid `⟨...⟩` notation: The expected type `p ∨ q` has more than one constructor
--      Note: This notation can only be used when the expected type is an
--            inductive type with a single constructor
--    造 `p ∨ q` 必须自己说清走哪一边（`Or.inl` / `Or.inr`）。

/-! ## 4. 消去规则：`Or.elim`（分情况讨论） -/

#check Or.elim
-- Or.elim {a b c : Prop} (h : a ∨ b) (left : a → c) (right : b → c) : c

-- 它内部做的事（`match` 属第 7 章，**看意思即可，不必懂语法**）：
#print Or.elim
-- theorem Or.elim : ∀ {a b c : Prop}, a ∨ b → (a → c) → (b → c) → c :=
-- fun {a b c} h left right =>
--   match h with
--   | Or.inl h => left h
--   | Or.inr h => right h
-- 也就是：「看 h 是 inl 还是 inr，是 inl 就用 left，是 inr 就用 right。」

/-! ## 5. 完整例子：把「或」交换过来（原文的例子） -/

-- 全名 + `show`（原文写法）
example (h : p ∨ q) : q ∨ p :=
  Or.elim h
    (fun hp : p => show q ∨ p from Or.intro_right q hp)
    (fun hq : q => show q ∨ p from Or.intro_left p hq)

-- 两个短写：Or.inr / Or.inl，以及点记号 h.elim
example (h : p ∨ q) : q ∨ p :=
  Or.elim h (fun hp => Or.inr hp) (fun hq => Or.inl hq)

example (h : p ∨ q) : q ∨ p :=
  h.elim (fun hp => Or.inr hp) (fun hq => Or.inl hq)

/-! ## 6. 两个分支可以交出**同一个**结论 -/

-- 左右两种情况，最后都落到同一个类型 `p`
example (h : p ∨ p) : p :=
  Or.elim h (fun hp => hp) (fun hp => hp)

-- 点记号版本（`h.elim` = `Or.elim h`，与 3-3 的 `h.left` 同一种机制）
example (h : p ∨ p) : p :=
  h.elim (fun hp => hp) (fun hp => hp)

/-! ## 7. 与 3-3 的 `And` 对照（复习） -/

#print And
-- structure And (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   And.left : a
--   And.right : b
-- constructor:
--   And.intro {a b : Prop} (left : a) (right : b) : a ∧ b
-- 对照上面的 `#print Or`：**头一行不同**（structure / inductive）、
-- **构造子个数不同**（1 个 / 2 个）——这就是 `⟨,⟩` 能不能用的分水岭。

/-! ## 8. `example` 与 `theorem`（3-3 讲过的） -/

-- 本文件全部用 `example`：不命名、不入库。
-- 需要名字时用 `theorem`（此时 p q 会被 Lean 收进 `∀`）：
theorem named : p → p := fun hp => hp
-- 打印形状（注意参数也被收进类型里）：
#check named
-- named (p : Prop) : p → p
