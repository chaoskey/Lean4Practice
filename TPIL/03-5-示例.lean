/-
  第 3 章 · 第 5 课 · 示例：否定 `¬`

  本文件全部用**证明项**（原文 3.3.3 也是）；**零 warning**。
-/

variable (p q r : Prop)

/-! ## 1. 引入规则：证 `¬p` = 假装 `p` 成立，然后造出矛盾 -/

-- 原文例子：(p → q) → ¬q → ¬p
example (hpq : p → q) (hnq : ¬q) : ¬p :=
  fun hp : p =>
  show False from hnq (hpq hp)

-- 目标最后写 `False` 的写法（实测：这种形状更稳，见讲义 §6）
example (h : ¬p) (hp : p) : False := h hp

/-! ## 2. `False` 与 `Not` 的类型（实测输出） -/

#check Not
-- Not (a : Prop) : Prop
#check False
-- False : Prop
#print False
-- inductive False : Prop
-- number of parameters: 0
-- constructors:
-- ⚠️ `constructors:` 后面**什么都没有** → 这就是「假」的含义：
--    证明必须由某个构造子造出来，而 `False` 一个都没有。

-- 对照 3-3 / 3-4：`And` 有 1 个构造子、`Or` 有 2 个。
#print And
#print Or

/-! ## 3. `¬p` 就是 `p → False`（按定义相等，两个方向） -/

example (h : ¬p) : p → False := h
example (h : p → False) : ¬p := h

/-! ## 4. 消去规则：`False.elim`（爆炸原理） -/

#check False.elim
-- False.elim.{u} {C : Sort u} (h : False) : C
#check absurd
-- absurd.{v} {a : Prop} {b : Sort v} (h₁ : a) (h₂ : ¬a) : b
#check True.intro
-- True.intro : True

-- 原文例子：矛盾推出任意结论
example (hp : p) (hnp : ¬p) : q := False.elim (hnp hp)

-- 同一个例子的 `absurd` 写法（⚠️ 参数顺序：先证明、后否定）
example (hp : p) (hnp : ¬p) : q := absurd hp hnp

-- 原文另一个例子：嵌套假设也能用 `absurd`
example (hnp : ¬p) (hq : q) (hqp : q → p) : r :=
  absurd (hqp hq) hnp

/-! ## 5. 把「一对」交给否定假设（`⟨,⟩` 的新用法） -/

example (h : ¬(p ∧ q)) (hp : p) : ¬q := fun hq => h ⟨hp, hq⟩
example (h : p ∧ ¬p) : False := absurd h.left h.right

/-! ## 6. `False.elim` 里面是什么（看一眼，`False.rec` 属第 7 章） -/

#print False.elim
#print absurd
-- def False.elim.{u} : {C : Sort u} → False → C :=
-- fun {C} h => False.rec (fun x => C) h
-- def absurd.{v} : {a : Prop} → {b : Sort v} → a → ¬a → b :=
-- fun {a} {b} h₁ h₂ => False.rec (fun x => b) ⋯
-- 意思：「手上有一份 `False` 的证明，就能造出任何类型的值。」

/-! ## 7. 优先级：`¬` 比 `→` 高 -/

#check (¬p → q)
-- ¬p → q : Prop      ← 读作「(¬p) → q」
#check (¬(p → q))
-- ¬(p → q) : Prop    ← 要表达「非(p→q)」**必须加括号**
