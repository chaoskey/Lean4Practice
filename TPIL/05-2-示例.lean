/- ============================================================
   第 5 章 · 第 2 课 · 示例：引入与假设
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入 4 个 tactic：`intro`、`intros`、`assumption`、`rfl`
      （外加 05-1 学的 `apply` / `exact`）。
   ============================================================ -/

/-! ## 例 A：最小例——目标是 `p → p`

   `intro hp` 把前提请进假设，目标从 `p → p` 变成 `p`。 -/

theorem exA (p : Prop) : p → p := by
  intro hp
  exact hp

#print exA


/-! ## 例 B：一次 `intro` 多个——**从外往里**剥

   目标 `∀ a b c : Nat, a = b → a = c → c = b` 展开是
   `(a : Nat) → (b : Nat) → (c : Nat) → a = b → a = c → c = b`；
   `intro a b c h₁ h₂` 就按这个顺序一个个剥。
   最后一步用 `Eq.trans` 与 `Eq.symm`（04-3 学的）。 -/

theorem exB : ∀ a b c : Nat, a = b → a = c → c = b := by
  intro a b c h₁ h₂
  exact Eq.trans (Eq.symm h₂) h₁

#print exB


/-! ## 例 C：`intros` ＋ `assumption`——**全程不起名字**

   `intros` 把前面几层一次剥光（名字由 Lean 起，带 `✝`、引用不到）；
   `assumption` 是**按类型**去假设里找，所以不需要名字。 -/

theorem exC (p q : Prop) : p → q → p ∧ q → p := by
  intros
  assumption

#print exC


/-! ## 例 D：`assumption` 收尾（传递性链）

   `apply Eq.trans h₁` 把目标 `x = w` 变成 `y = w`；
   `apply Eq.trans h₂` 再变成 `z = w`；`assumption` 用 `h₃` 收工。 -/

theorem exD (x y z w : Nat) (h₁ : x = y) (h₂ : y = z) (h₃ : z = w) : x = w := by
  apply Eq.trans h₁
  apply Eq.trans h₂
  assumption

#print exD


/-! ## 例 E：`rfl`

   `n + 0` 与 `n` **定义相等**（04-3 学的），所以 `rfl` 一步收工。
   看 `#print`：Lean 填的是 `Eq.refl (n + 0)`。 -/

theorem exE (n : Nat) : n + 0 = n := by
  rfl

#print exE


/-! ## 例 F：与项模式对照——`intro` 就是「交互式地写 `fun`」 -/

theorem exF_term : ∀ x : Nat, x = x := fun x => Eq.refl x

theorem exF_tactic : ∀ x : Nat, x = x := by
  intro x
  exact Eq.refl x

#print exF_term
#print exF_tactic


/-! ## 例 G：公理体检——五条应当全是 `does not depend on any axioms` -/

#print axioms exA
#print axioms exB
#print axioms exC
#print axioms exD
#print axioms exE
