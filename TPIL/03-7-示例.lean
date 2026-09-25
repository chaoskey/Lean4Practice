/-
  第 3 章 · 第 7 课 · 示例：辅助子目标 `have` / `suffices`

  本文件全部用**证明项**（原文 3.4 也是）；**零 warning**。
-/

variable (p q r : Prop)

/-! ## 1. `have`：先证一个中间事实，再拿它当假设用（原文例子） -/

theorem t1 (h : p ∧ q) : q ∧ p :=
  have hp : p := h.left
  have hq : q := h.right
  show q ∧ p from And.intro hq hp

-- ⚠️ `have` 的**类型不能省**，写错当场报错（下面故意写错，所以**不加** ```lean 标记）：
--
-- theorem bad (h : p ∧ q) : q ∧ p :=
--   have hp : q := h.left          -- ❌ 把 p 写成了 q
--   show q ∧ p from And.intro h q
--   ↑ error: Type mismatch

/-! ## 2. ⚠️ `have` 不是新东西：展开就是 `fun` + 应用（原文原话） -/

-- 「have h : p := s」接「t」 ≡ 「(fun (h : p) => t) s」
theorem t3 (h : p ∧ q) : q ∧ p :=
  (fun (hq : q) => (fun (hp : p) => And.intro hq hp) h.left) h.right

#print t1
-- fun p q h => have hp := h.left; have hq := h.right; have this := ⟨hq, hp⟩; this
#print t3
-- fun p q h => (fun hq => (fun hp => ⟨hq, hp⟩) h.left) h.right
-- ⚠️ 两者**是同一个证明**，只差 `have` 这层「糖」

/-! ## 3. `let`（02-6 的）也能在证明里用 —— 差别在读法，不在能不能 -/

theorem t4 (h : p ∧ q) : q ∧ p :=
  let hp : p := h.left
  let hq : q := h.right
  show q ∧ p from And.intro hq hp

/-! ## 4. `suffices`：倒着想「只要有这个就够了」（原文例子） -/

theorem t2 (h : p ∧ q) : q ∧ p :=
  have hp : p := h.left
  suffices hq : q from And.intro hq hp
  show q from And.right h

#print t2
-- fun p q h => have hp := h.left;
--   have hq := (have this := h.right; this); ⟨hq, hp⟩
-- ⚠️ `suffices` 内部**也是 `have`**（两个词，一个机制）

-- ⚠️ `suffices` 漏掉后半句是**语法错**（故意写错，所以**不加** ```lean 标记）：
--
-- theorem bad2 (h : p ∧ q) : q ∧ p :=
--   suffices hq : q
--   ↑ error: unexpected end of input; expected 'by' or ...

/-! ## 5. 什么时候真的需要它：目标要求**重新分组**时 -/

variable (p q r : Prop)

-- 正着写：先把内层拆成两个中间事实
theorem t6 (h : p ∧ (q ∧ r)) : (p ∧ q) ∧ r :=
  have hq : q := h.right.left
  have hr : r := h.right.right
  show (p ∧ q) ∧ r from And.intro (And.intro h.left hq) hr

-- 倒着写：一次 `suffices` 就够 —— 先说「只要有内层那个对就够了」
theorem t7 (h : p ∧ (q ∧ r)) : (p ∧ q) ∧ r :=
  suffices hqr : q ∧ r from And.intro (And.intro h.left hqr.left) hqr.right
  show q ∧ r from h.right
