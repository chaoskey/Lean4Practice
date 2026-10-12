/- ============================================================
   第 5 章 · 第 7 课 · 示例：结构化（一）
   （我写的示范——用与习题**不同**的例子，见 D9）

   ⚠️ 本文件必须**零警告零错误**（D9/D12）。
   ⚠️ 本课只引入：`·`（与原文用的 `.`）、`{ … }`、`case 标签 =>`、`intro | 模式 => …`。
      `show`／`have`／`let`（→ 05-8）、组合子（→ 05-9）不出现。
   ============================================================ -/

/-! ## 例 A：`·`——把两个子目标各包一块

   ⚠️ 块结束时**没解完会报错**（见讲义 §2.2），所以块是「漏解也会被抓」的写法。 -/

theorem exA (p q : Prop) (h : p ∨ q) : q ∨ p := by
  rcases h with hp | hq
  · exact Or.inr hp
  · exact Or.inl hq

#print exA


/-! ## 例 B：原文写的是 `.`（实测同样可用） -/

theorem exB (p q : Prop) (h : p ∨ q) : q ∨ p := by
  rcases h with hp | hq
  . exact Or.inr hp
  . exact Or.inl hq

#print exB


/-! ## 例 C：`case 标签 名字 =>`——**事后**聚焦到某一支，并命名

   `cases h`（不带 `with`）拆开的假设名字是**不可引用**的，`case` 顺手把它命名。 -/

theorem exC (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h
  case inl hp => exact Or.inr hp
  case inr hq => exact Or.inl hq

#print exC


/-! ## 例 D：`case 标签 =>` 也可以**不带名字**（当那一支用不着它时） -/

theorem exD (p q : Prop) (h : p ∨ q) (hp : p) : q ∨ p := by
  cases h
  case inl => exact Or.inr hp
  case inr hq => exact Or.inl hq

#print exD


/-! ## 例 E：`{ … }` 花括号块（原文给的另一种写法） -/

theorem exE (p q : Prop) (h : p ∧ q) : q ∧ p := by
  constructor
  { exact h.right }
  { exact h.left }

#print exE


/-! ## 例 F：`·` 里再嵌 `·`

   `h : p ∧ q ∧ r` 在 Lean 里结合成 `p ∧ (q ∧ r)`，所以 `h.left : p`、
   `h.right.left : q`、`h.right.right : r`。 -/

theorem exF (p q r : Prop) (h : p ∧ q ∧ r) : (p ∧ q) ∧ r := by
  constructor
  · constructor
    · exact h.left
    · exact h.right.left
  · exact h.right.right

#print exF


/-! ## 例 G：`intro` ＋ `| 构造子 名字 => …`（**原文 5.3 的写法**）

   ⚠️ 模式里要写**构造子**（`Or.inl`）；写短名 `inl` 会报 `Invalid pattern … [match_pattern]`。 -/

theorem exG (p q : Prop) : p ∨ q → q ∨ p := by
  intro
  | Or.inl hp => exact Or.inr hp
  | Or.inr hq => exact Or.inl hq

#print exG


/-! ## 例 H：`case` 的各支**顺序可以调换**（先做你认为容易的那一支）

   原文 5.3 原话：「新的子目标可以按**任意顺序**解决」。 -/

theorem exH (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h
  case inr hq => exact Or.inl hq
  case inl hp => exact Or.inr hp

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
