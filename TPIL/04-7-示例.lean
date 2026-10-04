/- ============================================================
   第 4 章 · 第 7 课 · 示例：存在量词 `∃`（二）——**消去**
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课**不含 tactic**：全部是证明项。
   ⚠️ 本课**只用 `Exists.elim`** 来拆 `∃`（`match`／`let ⟨…⟩`／`fun ⟨…⟩` 是第 7 章的，本课不碰）。
   ============================================================ -/

/-! ## 例 A：消去规则 `Exists.elim` 的类型 -/

#check @Exists.elim

/- 上一行会打出
     `(∃ x, p x) → (∀ (a : α), p a → b) → b`
   —— 注意**第二个参数是一个函数**，「见证 ＋ 证明」都得从它进来。 -/


/-! ## 例 B：最小的一次消去

   手上只有 `h : ∃ x, p x` 和 `f : ∀ x, p x → r`，要证 `r`。
   `Exists.elim` 把 `h` 拆开、把两样东西喂给 `f` —— **正好就是 `f` 的类型**。 -/

variable (α : Type) (p q : α → Prop) (r : Prop)

theorem exB_elim (h : ∃ x, p x) (f : ∀ x, p x → r) : r :=
  Exists.elim h f


/-! ## 例 C：拆开之后**只用一半**（把 `∧` 里的一边丢掉） -/

theorem exC_drop (h : ∃ x, p x ∧ q x) : ∃ x, p x :=
  Exists.elim h (fun w (hw : p w ∧ q w) => Exists.intro w hw.left)


/-! ## 例 D：⭐ 收口——偶数 ＋ 偶数

   把 04-4 的 `congrArg`、04-5 的 `calc`、04-6 的 `Exists.intro`、本课的 `Exists.elim`
   全用上。（原文那版是用 `rw` 写的，`rw` 属第 5 章。） -/

variable (a b : Nat)

def IsEven (n : Nat) : Prop := ∃ k, n = 2 * k

theorem exD_even_plus_even (h1 : IsEven a) (h2 : IsEven b) : IsEven (a + b) :=
  Exists.elim h1 (fun w1 (hw1 : a = 2 * w1) =>
  Exists.elim h2 (fun w2 (hw2 : b = 2 * w2) =>
    Exists.intro (w1 + w2)
      (calc a + b
        _ = 2 * w1 + b       := congrArg (fun x => x + b) hw1
        _ = 2 * w1 + 2 * w2  := congrArg (fun y => 2 * w1 + y) hw2
        _ = 2 * (w1 + w2)    := (Nat.mul_add 2 w1 w2).symm)))


/-! ## 例 E：公理体检

   四个例子都应该**不依赖任何公理**。 -/

#print axioms exB_elim
#print axioms exC_drop
#print axioms exD_even_plus_even
