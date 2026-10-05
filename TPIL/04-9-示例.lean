/- ============================================================
   第 4 章 · 第 9 课 · 示例：章末综合（收官）
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 全程**只用证明项**：`fun` / `Iff.intro` / `Or.elim` / `Classical.em`。
      唯一的「非纯构造」例子是**例 D 的第二条**，它**故意**用经典，用来对照公理。
   ============================================================ -/

/-! ## 例 A：目标是 `↔` —— `Iff.intro` 两个方向各一个 `fun` -/

theorem exA_iff (p q : Prop) : p ∧ q ↔ q ∧ p :=
  Iff.intro
    (fun h => And.intro h.right h.left)
    (fun h => And.intro h.right h.left)


/-! ## 例 B：`∀` 的**目标**（写 `fun x`）与 `∀` 的**假设**（写 `h x`） -/

theorem exB_forall (α : Type) (p q r : α → Prop)
    (h1 : ∀ x, p x → q x) (h2 : ∀ x, q x → r x) : ∀ x, p x → r x :=
  fun x hp => h2 x (h1 x hp)


/-! ## 例 C：手上是 `∨` —— 用 `Or.elim` 分情况（**不是** `byCases`） -/

theorem exC_or (p q : Prop) (h : p ∨ q) : q ∨ p :=
  h.elim (fun hp => Or.inr hp) (fun hq => Or.inl hq)


/-! ## 例 D：⭐ **构造 vs 经典**——同一件「否定」的两半，强度不一样

   · 第一条（`p → ¬¬p`）**纯构造**：零公理。
   · 第二条（`¬¬p → p`）**必须用经典**：用 `Classical.em`（**项**，不是 tactic）。

   下面例 F 会把两条的公理**都打出来**对照。 -/

theorem exD_constructive (p : Prop) : p → ¬¬p :=
  fun hp hnp => hnp hp

theorem exD_classical (p : Prop) : ¬¬p → p :=
  fun hnn => (Classical.em p).elim (fun hp => hp) (fun hnp => absurd hnp hnn)


/-! ## 例 E：反例的**关键一步**（机器验证）

   「`(∀ x : Bool, x = true) ∨ (∀ x : Bool, x = false)` 是**假的**」——
   这就是§4 那个反例里，能被机器验掉的那一半。

   （另一半「`Bool` 只有两个值」要分类讨论，属**第 7 章**，本课程只当数学事实用。） -/

theorem exE_not_both (h : (∀ x : Bool, x = true) ∨ (∀ x : Bool, x = false)) : False :=
  h.elim
    (fun h1 => Bool.false_ne_true (h1 false))
    (fun h2 => Bool.false_ne_true (Eq.symm (h2 true)))


/-! ## 例 F：公理体检——**唯一可靠的判据**

   看前两条：一个零公理，一个带三条例经典公理。 -/

#print axioms exA_iff
#print axioms exB_forall
#print axioms exC_or
#print axioms exD_constructive
#print axioms exD_classical
#print axioms exE_not_both
