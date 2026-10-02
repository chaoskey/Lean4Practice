/-
  第 4 章 · 第 4 课 · 示例：用等价做替换（`Eq.subst` / `▸` / `congr`）

  我写的示范。已验证：**零错误、零警告**。

  ⚠️ 这些例子**都不是** `04-4-习题.lean` 里的题目——
     习题用的是另一批命题、另一批类型。
-/

/- ============================================================
   例 A：四个工具的类型
   ============================================================ -/
#check Eq.subst
#check @Eq.subst
#check congrArg
#check congrFun
#check congr

/- `Eq.subst` 的关键是那个 `motive : α → Prop`——**「带一个洞的句子」**：
   喂它一个 `α` 的元素，它吐一个命题。`h₁ : a = b` 说洞外面是 `a`、洞里面是 `b`；
   它把 `motive a` 的证明变成 `motive b` 的证明。
-/

/- ============================================================
   例 B：元素等式上的替换（原文 4.2 的两个写法）
   —— 洞是 `fun x => p x`，也就是 `p` 自己
   ============================================================ -/
theorem exB (α : Type) (a b : α) (p : α → Prop) (h1 : a = b) (h2 : p a) : p b := h1 ▸ h2
theorem exB2 (α : Type) (a b : α) (p : α → Prop) (h1 : a = b) (h2 : p a) : p b := Eq.subst h1 h2

/- ============================================================
   例 C：`▸` 还能在**类型**里替换（`Eq.subst` 不行——它的 motive 只能是 `Prop`）
   ============================================================ -/
def exC (α : Type) (p : α → Type) (a b : α) (h : a = b) (x : p a) : p b := h ▸ x

/- ⚠️ 这里必须写 `def` 而不是 `theorem`：上面那句话的类型是 `… → p b`，而 `p b : Type`，
   整个类型**不是命题**——`theorem` 只收 `Prop`（03-2 学过的规矩）。
-/

/- ============================================================
   例 D：`h` 的方向反了怎么办
   —— `▸` 两个方向都试；`Eq.subst` 要求 `h : a = b`，反了要自己 `.symm`
   ============================================================ -/
theorem exD1 (α : Type) (p : α → Prop) (a b : α) (h : b = a) (h2 : p a) : p b := h ▸ h2
theorem exD2 (α : Type) (p : α → Prop) (a b : α) (h : b = a) (h2 : p a) : p b := Eq.subst h.symm h2

/- ============================================================
   例 E：`congr` 三兄弟——在「函数应用」上替换
   ============================================================ -/
theorem exE1 (f : Nat → Nat) (a b : Nat) (h : a = b) : f a = f b := congrArg f h
theorem exE2 (f g : Nat → Nat) (a : Nat) (h : f = g) : f a = g a := congrFun h a
theorem exE3 (f g : Nat → Nat) (a b : Nat) (hf : f = g) (ha : a = b) : f a = g b := congr hf ha

/- ⚠️ 注意它们**给的是等式**（`f a = f b` 之类），不是「改写过后的证明」。
   要拿它们的结果去改别的东西，还得再 `▸` 一下——见例 G。
-/

/- ============================================================
   例 F：`Nat` 表的用法（挑几条）＋ 把两条等式接起来
   ============================================================ -/
theorem exF1 (a b c : Nat) : a + b + c = c + (a + b) := Nat.add_comm (a + b) c
theorem exF2 (a b : Nat) : a + b = b + a + 0 := (Nat.add_comm a b).trans (Nat.add_zero (b + a)).symm
theorem exF3 (a b c : Nat) : a * (b + c) = a * b + a * c := Nat.mul_add a b c

/- ============================================================
   例 G：两件套——先「造」等式，再「用」等式
   ============================================================ -/
theorem exG (α : Type) (P Q : α → Prop) (a : α) (h : P = Q) (h2 : P a) : Q a :=
  (congrFun h a) ▸ h2

/- `congrFun h a : P a = Q a` 是一条**等式**；再用 `▸` 把 `h2 : P a` 改成 `Q a`。
-/

/- ============================================================
   公理体检：本课全部是构造性的
   ============================================================ -/
#print axioms exB
#print axioms exB2
#print axioms exC
#print axioms exD1
#print axioms exD2
#print axioms exE1
#print axioms exE2
#print axioms exE3
#print axioms exF1
#print axioms exF2
#print axioms exF3
#print axioms exG
