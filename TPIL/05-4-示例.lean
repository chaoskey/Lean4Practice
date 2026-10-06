/- ============================================================
   第 5 章 · 第 4 课 · 示例：拆开假设
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入两件：`cases`（带／不带 `with`）与 `intro ⟨…⟩` 模式
      （外加前面学的 `intro`／`intros`／`exact`／`apply`／`rename_i` 等）。
   ============================================================ -/

/-! ## 例 A：`cases` 拆 `∨`——两支各写各的

   `h : p ∨ q` 有两种造法（`Or.inl`／`Or.inr`），所以 `cases h with` 要写**两支**；
   `inl hp` 里的 `hp : p`、`inr hq` 里的 `hq : q` 就是新摆进来的东西。 -/

theorem exA (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq

#print exA


/-! ## 例 B：`cases` 拆 `∧`——只有一支

   `∧` 只有一种造法（`And.intro`），所以标签是 `case intro`、`with` 里也写 `intro`；
   两个名字按顺序对上：先 `p` 后 `q`。 -/

theorem exB (p q : Prop) (h : p ∧ q) : q ∧ p := by
  cases h with
  | intro hp hq => exact ⟨hq, hp⟩

#print exB


/-! ## 例 C：`cases` 拆 `∃`——拿出发觉者与证据

   `intro w hw` 里：`w` 是那个具体的东西，`hw : P w` 是「它满足 `P`」的证据。 -/

theorem exC (α : Type) (P : α → Prop) (h : ∃ x, P x) : ∃ x, P x := by
  cases h with
  | intro w hw => exact ⟨w, hw⟩

#print exC


/-! ## 例 D：不带 `with` ＋ `rename_i`（只有一个目标时）

   `cases h` 在 `∧` 上只产生**一个**目标，所以没有 `with` 也能用 05-3 的 `rename_i`
   给那两条带 `✝` 的名字补上正常名字。 -/

theorem exD (p q : Prop) (h : p ∧ q) : q ∧ p := by
  cases h
  rename_i hp hq
  exact ⟨hq, hp⟩

#print exD


/-! ## 例 E：`intro ⟨hp, hq⟩`——请进来的同时就拆（`∧` 在目标左边）

   注意：这里的 `⟨hp, hq⟩` 是**模式**（拆），不是项。 -/

theorem exE (p q r : Prop) (h : p → q → r) : p ∧ q → r := by
  intro ⟨hp, hq⟩
  exact h hp hq

#print exE


/-! ## 例 F：`intro ⟨w, hw⟩`（`∃` 在目标左边） -/

theorem exF (α : Type) (P : α → Prop) (Q : Prop) (h : ∀ x, P x → Q) : (∃ x, P x) → Q := by
  intro ⟨w, hw⟩
  exact h w hw

#print exF


/-! ## 例 G：同一个 `⟨⟩`，两个角色

   例 E 里 `intro ⟨hp, hq⟩` 的 `⟨⟩` 是**模式**（拆）；
   下面 `exact h ⟨hp, hq⟩` 的 `⟨⟩` 是**项**（造）——位置不同，干的事正好相反。 -/

theorem exG (p q r : Prop) (h : p ∧ q → r) : q → p → r := by
  intro hq hp
  exact h ⟨hp, hq⟩

#print exG


/-! ## 例 H：公理体检

   这七条都是构造性的——`#print axioms` 一查便知。 -/

#print axioms exA
#print axioms exB
#print axioms exC
#print axioms exD
#print axioms exE
#print axioms exF
#print axioms exG
