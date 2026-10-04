/- ============================================================
   第 4 章 · 第 8 课 · 示例：匿名 `have` 与 `this`
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课**不含 tactic**：全部是证明项。
   ============================================================ -/

/-! ## 例 A：最小的一次——`this` 还能直接用在**下一行**的证明里 -/

theorem exA_min (p q : Prop) (hp : p) (hpq : p → q) : q :=
  have : p := hp
  have : q := hpq this
  this


/-! ## 例 B：同一个命题，**带标签版**与**匿名版**对照

   两版证的是同一个命题、用的是同一批零件，区别只在「有没有给中间结论起名字」。 -/

theorem exB_labeled (f : Nat → Nat) (h : ∀ x : Nat, f x = f (x + 1)) : f 0 = f 2 :=
  have h01 : f 0 = f 1 := h 0
  have h02 : f 0 = f 2 := h01.trans (h 1)
  show f 0 = f 2 from h02

theorem exB_anon (f : Nat → Nat) (h : ∀ x : Nat, f x = f (x + 1)) : f 0 = f 2 :=
  have : f 0 = f 1 := h 0
  have : f 0 = f 2 := this.trans (h 1)
  show f 0 = f 2 from this


/-! ## 例 C：**混用**——有一条要「回头」用，它就必须起名字

   目标是 `f 0 = f 2 ∧ f 2 = f 0`：`f 0 = f 2` 这条要用两次
   （一次当 `∧` 的左半边，一次拿来做 `.symm`），所以给它起名 `h02`；
   另一条用完就不管了，匿名即可。 -/

theorem exC_mixed (f : Nat → Nat) (h : ∀ x : Nat, f x = f (x + 1)) : f 0 = f 2 ∧ f 2 = f 0 :=
  have h02 : f 0 = f 2 := (h 0).trans (h 1)
  have : f 2 = f 0 := h02.symm
  ⟨h02, this⟩


/-! ## 例 D：带名字的 `have` **不会顶掉** `this`

   下面第二条是**有名字**的（`_h1`），可 `this` 仍然指着第一条**匿名**的 `p`。 -/

theorem exD_survives (p q : Prop) (hp : p) (hq : q) : p :=
  have : p := hp
  have _h1 : q := hq
  this


/-! ## 例 E：公理体检

   四个例子都应该**不依赖任何公理**。
   ⚠️ 但记住讲义 §6 那条：**`#print axioms` 判断不了「内部用没用 tactic」**。 -/

#print axioms exA_min
#print axioms exB_labeled
#print axioms exB_anon
#print axioms exC_mixed
#print axioms exD_survives
