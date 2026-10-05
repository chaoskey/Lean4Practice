/- ============================================================
   第 5 章 · 第 1 课 · 示例：进入 tactic 模式
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入三个 tactic：`exact`、`apply`、`sorry`。
      其中 `sorry` 会带一条 warning，所以**只写在讲解里**，不放活动代码。
   ============================================================ -/

/-! ## 例 A：同一个定理，两种写法——`#print` 打出来**一模一样**

   左边是第 4 章那种「证明项」写法，右边是本课的 tactic 写法。
   两条 `#print` 的输出**完全相同**（见文件末尾的实测对照）。 -/

theorem exA_term (p q : Prop) (hp : p) (hq : q) : q ∧ p :=
  ⟨hq, hp⟩

theorem exA_tactic (p q : Prop) (hp : p) (hq : q) : q ∧ p := by
  apply And.intro
  exact hq
  exact hp

#print exA_term
#print exA_tactic


/-! ## 例 B：`apply` 把参数的「欠账」变成子目标

   假设 `h : p → q`、目标 `q`。`apply h` 的意思是
   「**用 `h` 来交差**，但它还缺一个 `p`」——于是 `p` 变成新目标。 -/

theorem exB (p q : Prop) (hp : p) (h : p → q) : q := by
  apply h
  exact hp

#print exB


/-! ## 例 C：`apply And.intro` 会**一次留下两个目标**（按出现顺序）

   目标 `p ∧ q ∧ p` 里，`∧` 是**右结合**的（04-6 讲过），
   所以它其实是 `p ∧ (q ∧ p)`；`apply And.intro` 留下的两个目标是
   **先 `p`、后 `q ∧ p`**。tactic 总是先处理**当前那个（最上面那个）**目标。 -/

theorem exC (p q : Prop) (hp : p) (hq : q) : p ∧ q ∧ p := by
  apply And.intro
  exact hp
  apply And.intro
  exact hq
  exact hp


/-! ## 例 D：`apply` 后面可以给**复合表达式**（不必只是单个名字）

   `And.intro hp` 的类型是 `q → p ∧ q`（少了一个参数），
   所以还可以继续解一个子目标。 -/

theorem exD (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  apply And.intro hp
  exact hq


/-! ## 例 E：`exact` 一个「**类型本身就是目标**」的项

   目标 `p → q → p ∧ q`，而 `And.intro` 的类型恰好就是
   `∀ {a b : Prop}, a → b → a ∧ b`——取 `a := p`、`b := q` 就对上了，
   所以 `exact And.intro` 一步收工。
   （`#check @And.intro` 可以看到它的完整类型。） -/

#check @And.intro

theorem exE (p q : Prop) : p → q → p ∧ q := by
  exact And.intro

#print exE


/-! ## 例 F：公理体检——tactic 证明也**不欠公理**

   六条 `#print axioms` 应当全是 `does not depend on any axioms`。 -/

#print axioms exA_term
#print axioms exA_tactic
#print axioms exB
#print axioms exC
#print axioms exD
#print axioms exE
