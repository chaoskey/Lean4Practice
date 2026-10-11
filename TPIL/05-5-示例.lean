/- ============================================================
   第 5 章 · 第 5 课 · 示例：造出目标
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入三件：`constructor`、`left`／`right`、`exists`
      （外加前面学的 `intro`／`cases`／`apply`／`exact` 等）。
   ============================================================ -/

/-! ## 例 A：`constructor` 造 `∧`——两个子目标，一行交一个

   `constructor` 之后目标变成 `⊢ p` 和 `⊢ q`（标签是 `case left`／`case right`，
   就是 05-4 §2.4 拆 `∧` 时见过的名字）。 -/

theorem exA (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  constructor
  exact hp
  exact hq

#print exA


/-! ## 例 B：`left` 造 `∨` 的**左边**

   只留一个子目标，所以不需要「一行交一个」的排法。 -/

theorem exB (p q : Prop) (hp : p) : p ∨ q := by
  left
  exact hp

#print exB


/-! ## 例 C：`right` 造 `∨` 的**右边**

   ⚠️ 这一条**不能**用 `constructor` 顶替：`constructor` 在 `∨` 上只挑第一个构造子
   （`Or.inl`，也就是要 `p`），而这里只有 `hq : q`。 -/

theorem exC (p q : Prop) (hq : q) : p ∨ q := by
  right
  exact hq

#print exC


/-! ## 例 D：`constructor` 一步收工（一个构造子、没有参数）

   `True` 只有一种造法 `True.intro`，且不带参数——所以没有子目标。 -/

theorem exD : True := by
  constructor

#print exD


/-! ## 例 E：`exists` 给出 witness，剩下的目标还要证

   `exists w` 之后目标是 `⊢ Q w`；这里用 `f w hw` 交掉。
   ⚠️ 剩下那个目标**不一定还在**（见例 F）——它取决于上下文能不能自动收尾。 -/

theorem exE (α : Type) (P Q : α → Prop) (w : α) (hw : P w) (f : ∀ x, P x → Q x) : ∃ x, Q x := by
  exists w
  exact f w hw

#print exE


/-! ## 例 F：`exists` 顺手收尾（它的实现里有 `try trivial`）

   `exists 0` 之后剩下 `⊢ 0 = 0`，被 `rfl` 收掉——**没有子目标**。
   所以**别**在后面再补一行（那会报 `No goals to be solved`）。 -/

theorem exF : ∃ n : Nat, n = n := by
  exists 0

#print exF


/-! ## 例 G：`apply And.intro` 与 `constructor` 等价

   两条路造出的子目标一样（都是 `⊢ p`、`⊢ q`）。 -/

theorem exG (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  apply And.intro
  exact hp
  exact hq

#print exG


/-! ## 例 H：同一批目标，也可以用**项**直接交（前几课学的写法）

   与例 A／B／C／E 证的是同一件事，只是把 tactic 换成了证明项。 -/

theorem exH1 (p q : Prop) (hp : p) (hq : q) : p ∧ q := ⟨hp, hq⟩
theorem exH2 (p q : Prop) (hp : p) : p ∨ q := Or.inl hp
theorem exH3 (p q : Prop) (hq : q) : p ∨ q := Or.inr hq
theorem exH4 (p q : Prop) (hp : p) (hq : q) : p ∧ q := And.intro hp hq
theorem exH5 (α : Type) (P : α → Prop) (w : α) (hw : P w) : ∃ x, P x := Exists.intro w hw

#print exH1
#print exH2
#print exH3
#print exH4
#print exH5


/-! ## 例 I：公理体检

   这些都是构造性的——`#print axioms` 一查便知。 -/

#print axioms exA
#print axioms exB
#print axioms exC
#print axioms exD
#print axioms exE
#print axioms exF
#print axioms exG
#print axioms exH1
#print axioms exH2
#print axioms exH3
#print axioms exH4
#print axioms exH5
