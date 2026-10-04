/- ============================================================
   第 4 章 · 第 6 课 · 示例：存在量词 `∃`（一）——**构造**
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课**不含 tactic**：全部是证明项。
   ⚠️ 本课**只讲「怎么证出 ∃」**；「拿到 ∃ 怎么用」是下一课 04-7。
   ============================================================ -/

/-! ## 例 A：`∃` 与它的构造规则，各是什么类型 -/

#check Exists
#check @Exists.intro


/-! ## 例 B：最小的一次构造（见证 ＋ 证明） -/

theorem exB_simple : ∃ n : Nat, n = 0 :=
  ⟨0, rfl⟩


/-! ## 例 C：见证用现成的引理「造」出来

   目标是 `∃ m, n < m`——见证取 `n + 1`，证明用 `Nat.lt_succ_self`。 -/

theorem exC_witness (n : Nat) : ∃ m, n < m :=
  ⟨n + 1, Nat.lt_succ_self n⟩


/-! ## 例 D：**套娃**——匿名构造子遇到 `∧` 会自动再套一层

   目标 `∃ m, 0 < m ∧ m < 2`，见证 `1`：
     · `0 < 1` 用 `Nat.zero_lt_succ 0`
     · `1 < 2` 用 `Nat.lt_succ_self 1`
   `⟨1, … , …⟩` 能写成「一个见证 ＋ 两个证明」，靠的就是 `∧` 也是 `⟨⟩`。 -/

theorem exD_nest : ∃ m : Nat, 0 < m ∧ m < 2 :=
  ⟨1, Nat.zero_lt_succ 0, Nat.lt_succ_self 1⟩


/-! ## 例 E：同一个证明的**显式版**（对照例 D）

   一环一环写清楚：外层是 `Exists.intro`，里层是 `And.intro`。
   **拿不准能不能省 `⟨⟩` 时，就写这个版本。** -/

theorem exE_explicit : ∃ m : Nat, 0 < m ∧ m < 2 :=
  Exists.intro 1 (And.intro (Nat.zero_lt_succ 0) (Nat.lt_succ_self 1))


/-! ## 例 F：⭐ 谓词 `p` 是 Lean **推**出来的

   `Exists.intro` 的谓词是隐式参数。下面这个 `∃` 里的谓词是哪一个？
   用 `pp.explicit` 把隐式参数打出来看。 -/

variable (k : Nat → Nat)

theorem exF_infer (hk : k 2 = 2) : ∃ x, k x = x :=
  ⟨2, hk⟩

set_option pp.explicit true in
#print exF_infer


/-! ## 例 G：公理体检

   六个例子都应该**不依赖任何公理**。 -/

#print axioms exB_simple
#print axioms exC_witness
#print axioms exD_nest
#print axioms exE_explicit
#print axioms exF_infer
