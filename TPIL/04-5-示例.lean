/- ============================================================
   第 4 章 · 第 5 课 · 示例：计算式证明 `calc`
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课**不含 tactic**：全部是证明项。
   ============================================================ -/

/-! ## 例 A：一切的底子——`trans` -/

#check Eq.trans

/- 上一行会打出 `Eq.trans` 的类型。**本课所有东西都建在它上面**。 -/


/-! ## 例 B：没有 `calc` 时怎么写（对照用） -/

theorem exB_trans (a b c d : Nat) (h1 : a = b) (h2 : b = c) (h3 : c = d) : a = d :=
  (h1.trans h2).trans h3


/-! ## 例 C：同一个证明，改成 `calc`（讲义 §2 的**写法一**）

   ⚠️ 与例 B **证的是同一个命题**，右边给的也**是同一批假设**——
   区别只在「摆法」。 -/

theorem exC_calc (a b c d : Nat) (h1 : a = b) (h2 : b = c) (h3 : c = d) : a = d :=
  calc
    a = b := h1
    _ = c := h2
    _ = d := h3


/-! ## 例 D：**对齐写法**（讲义 §2 的写法二）

   第一行 `calc a` 只给起点；后面每行以 `_` 开头。 -/

theorem exD_aligned (a b c d : Nat) (h1 : a = b) (h2 : b = c) (h3 : c = d) : a = d :=
  calc a
    _ = b := h1
    _ = c := h2
    _ = d := h3


/-! ## 例 E：链里混用 `congrArg` / `.symm` / `Nat` 表

   这是原文那个主例子的「小号版」：每一格**只交自己那一小步**的证明。
   第 2 格用的是 `h2.symm`——因为 `h2` 的方向和这一格要的**相反**。 -/

theorem exE_mixed (a b c : Nat) (h1 : a = b) (h2 : c = b) : a + 1 = 1 + c :=
  calc
    a + 1 = b + 1 := congrArg (fun x => x + 1) h1
    _ = c + 1 := congrArg (fun x => x + 1) h2.symm
    _ = 1 + c := Nat.add_comm c 1


/-! ## 例 F：⭐ `calc` 到底被推成什么？（讲义 §3 那个实测的出处）

   下面把例 C 的证明项打印出来——你会看到它**就是 `trans`**。 -/

set_option pp.proofs true in
#print exC_calc


/-! ## 例 G：公理体检

   四个例子都应该**不依赖任何公理**。 -/

#print axioms exB_trans
#print axioms exC_calc
#print axioms exD_aligned
#print axioms exE_mixed
