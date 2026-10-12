/- ============================================================
   第 5 章 · 第 6 课 · 示例：收尾与模式
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入四件：`rintro`、`rcases`、tactic 里的 `match`、`contradiction`
      （外加前面学的 `intro`／`cases`／`exact`／`constructor`／`exists` 等）。
   ============================================================ -/

/-! ## 例 A：`rintro` 收**多个**名字（不用模式）

   等价于写两行 `intro`（一行收一个），`rintro` 把它们并到一行。 -/

theorem exA (p q : Prop) : p → q → p ∧ q := by
  rintro hp hq
  exact ⟨hp, hq⟩

#print exA


/-! ## 例 B：`rintro ⟨…⟩`——把**目标左边那块**请进来的**同时**拆**它**一层

   与 05-4 的 `intro hpq` ＋ `cases hpq with | intro hp hq => …` 效果一样，只是短。 -/

theorem exB (p q : Prop) : p ∧ q → q := by
  rintro ⟨hp, hq⟩
  exact hq

#print exB


/-! ## 例 C：`rintro (… | …)`——把**目标左边那块**分成两条路请进来

   ⚠️ 这会产生**两个**目标（`case inl`／`case inr`），所以后面**一行交一个**。 -/

theorem exC (p q : Prop) : p ∨ q → q ∨ p := by
  rintro (hp | hq)
  exact Or.inr hp
  exact Or.inl hq

#print exC


/-! ## 例 D：`rcases h with ⟨…⟩`——拆**假设 `h`** 的省事写法（不分支） -/

theorem exD (p q : Prop) (h : p ∧ q) : p := by
  rcases h with ⟨hp, hq⟩
  exact hp

#print exD


/-! ## 例 E：`rcases h with ⟨w, hw⟩`——拆**类型是 `∃` 的假设 `h`**（拿出 witness 与证据） -/

theorem exE (α : Type) (P : α → Prop) (h : ∃ x, P x) : ∃ x, P x := by
  rcases h with ⟨w, hw⟩
  exact ⟨w, hw⟩

#print exE


/-! ## 例 F：tactic 版 `match`——把**假设 `h`** 按 `∨` 分开

   ⚠️ 模式里写的是**构造子全名** `Or.inl`／`Or.inr`——
   短名 `inl`／`inr` 只属于 `cases … with` 的标签（见讲义 §4.2）。 -/

theorem exF (p q : Prop) (h : p ∨ q) : q ∨ p := by
  match h with
  | Or.inl hp => exact Or.inr hp
  | Or.inr hq => exact Or.inl hq

#print exF


/-! ## 例 G：tactic 版 `match`——**一次把两个表达式都**分开（不用的写 `_`）

   `cases` 一次只能拆一个；`match h₁, h₂ with` 可以一起看。 -/

theorem exG (p q : Prop) (h₁ h₂ : p ∨ q) : q ∨ p := by
  match h₁, h₂ with
  | Or.inl hp, _ => exact Or.inr hp
  | Or.inr hq, _ => exact Or.inl hq

#print exG


/-! ## 例 H：`contradiction` 一步收尾

   官方文档列的第三种形状：「自己不等于自己」这类明显假的东西。
   注意目标 `p` 可以是**任何**命题。 -/

theorem exH (p : Prop) (x : Nat) (h : x ≠ x) : p := by
  contradiction

#print exH


/-! ## 例 I：公理体检

   这八条都是构造性的——`#print axioms` 一查便知。 -/

#print axioms exA
#print axioms exB
#print axioms exC
#print axioms exD
#print axioms exE
#print axioms exF
#print axioms exG
#print axioms exH
