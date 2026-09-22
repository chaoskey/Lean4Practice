/-
  第 3 章 · 第 1 课：命题即类型（Propositions as Types）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `03-1-习题.lean`。

  检查本文件：
    lake env lean TPIL/03-1-示例.lean
-/

/-! ## 1. 命题构造子的「本名」 -/

#check And          -- And (a b : Prop) : Prop
#check Or           -- Or (a b : Prop) : Prop
#check Not          -- Not (a : Prop) : Prop
#check True         -- True : Prop
#check False        -- False : Prop

/-! ## 2. 记号只是「函数形式」的糖（记号 vs 本名） -/

variable (p q r : Prop)

#check And p q              -- p ∧ q : Prop
#check Or (And p q) r       -- p ∧ q ∨ r : Prop
#check (p ∧ q → q ∧ p)      -- p ∧ q → q ∧ p : Prop

/-! ## 3. `Prop` 对箭头封闭：两个命题之间的箭头，还是命题 -/

#check (p → q)              -- p → q : Prop

/-! ## 4. 原文 3.1 里那个 `Implies`（自己定义出来，和 `→` 对比）

    原文用它说明「本可以另造一套断言语言」，然后指出它是**多余的**。 -/

def Implies (p q : Prop) : Prop := p → q

#check Implies                      -- Implies (p q : Prop) : Prop
#check Implies (And p q) (And q p)  -- Implies (p ∧ q) (q ∧ p) : Prop

/-! ## 5. 同一个 `fun`，两种身份（Curry–Howard） -/

#check (fun (x : Nat) => x)     -- fun x => x : Nat → Nat     ← 恒等函数
#check (fun (hp : p) => hp)     -- fun hp => hp : p → p       ← 「p 蕴含 p」的证明

/-! ## 6. 本课不引入的东西

    · `structure`（原文那个 `Proof p` 的写法）—— 第 7 章
    · `axiom` —— 能用但危险（原文自己说它「可能破坏一致性」）
    · `Sort` / `universe u` / `Type u`（宇宙多态，还没有归属的课）
    · 怎么写证明（`intro` / `exact` / `rw`…）—— 下一课 3-2 -/
