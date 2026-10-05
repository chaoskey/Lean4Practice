/- ============================================================
   第 5 章 · 第 3 课 · 示例：搬动上下文
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入 5 个 tactic：`revert`、`generalize`、`rename_i`、
      `unhygienic`、`repeat`（外加前面学的 `intro`／`intros`／
      `assumption`／`rfl`／`apply`／`exact`）。
   ============================================================ -/

/-! ## 例 A：`revert` 是 `intro` 的逆操作

   `intro hp` 把前提请进假设，`revert hp` 又把它搬回目标——
   目标从 `p` 回到 `p → p`，再 `intro hp` 就回到原样。 -/

theorem exA (p : Prop) : p → p := by
  intro hp
  revert hp
  intro hp
  exact hp

#print exA


/-! ## 例 B：退回的假设，收尾时 Lean 会**自动应用**回来

   `revert hp hq` 之后目标是 `p → q → p`，正好和 `h : p → q → p` 对上；
   下面的 `#print` 会打出 `fun p q hp hq h => h hp hq`——
   **最后那段 `h hp hq` 就是 Lean 自动补上的**。 -/

theorem exB (p q : Prop) (hp : p) (hq : q) (h : p → q → p) : p := by
  revert hp hq
  exact h

#print exB


/-! ## 例 C：`generalize` 带 `h :`——换掉表达式，同时留下等式

   目标 `n + 0 = n` 里的 `n + 0` 被换成新变量 `k`，并多出一条 `hk : n + 0 = k`。

   ⚠️ 下面 `#print exC` 打出来的项里 **`k` 不见了、变回了 `n + 0`**
   （打印器会把这种局部定义展开；本课不深究它什么时候展开）。 -/

theorem exC (n : Nat) : n + 0 = n := by
  generalize hk : n + 0 = k
  exact hk.symm

#print exC


/-! ## 例 D：`generalize … at h`——连假设里的表达式一起换

   `at h` 把 `h : a + 0 = b` 也换成 `h : k = b`，
   于是 `Eq.trans hk h`（`hk : a + 0 = k`）给出 `a = b`。 -/

theorem exD (a b : Nat) (h : a + 0 = b) : a = b := by
  generalize hk : a + 0 = k at h
  exact Eq.trans hk h

#print exD


/-! ## 例 E：`rename_i`——只改**最后**那一个不可及的名字

   `intros` 起的两条名字都带 `✝`、引用不到；
   `rename_i hq` 只把**最后**那条（类型是 `q` 的）改名成 `hq`。 -/

theorem exE (p q : Prop) : p → q → q := by
  intros
  rename_i hq
  exact hq

#print exE


/-! ## 例 F：`unhygienic`——让 `intro` 起普通名字

   这条就是 Lean 自带源码文档里的原例（源码分两行写，这里并成一行）。 -/

theorem exF : ∀ x : Nat, x = x := by
  unhygienic intro
  exact Eq.refl x

#print exF


/-! ## 例 G：`repeat intro`——一层不够就再来一层

   目标 `p → q → r → p` 有三层箭头，`repeat intro` 一次剥光；
   之后 `assumption` 按类型找到 `p` 的那条前提。 -/

theorem exG (p q r : Prop) : p → q → r → p := by
  repeat intro
  assumption

#print exG


/-! ## 例 H：`repeat` 会顺次走到后面的子目标

   `apply And.intro` 造出两个子目标；`repeat assumption`
   **第一轮交掉第一个**，**第二轮交掉第二个**，第三轮无目标可做就停。 -/

theorem exH (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  apply And.intro
  repeat assumption

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
