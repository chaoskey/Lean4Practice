/-
  第 3 章 · 第 8 课 · 示例：经典逻辑（排中律 / 双重否定消去 / 反证）

  本文件全部用**证明项**（原文 3.5 也是）；**零 warning**。
-/

/-! ## 1. 排中律 `em`：在 `Classical` 命名空间里 -/

open Classical

variable (p : Prop)

#check em p
-- em p : p ∨ ¬p

#check Classical.em
-- Classical.em : ∀ (p : Prop), p ∨ ¬p

-- ⚠️ 不 `open Classical` 就写 `em` 会报错（**故意写错**，用普通代码块）：
--
-- variable (p : Prop)
-- #check em p
-- ↑ error(lean.unknownIdentifier): Unknown identifier `em`

/-! ## 2. 构造性地证不出 `p ∨ ¬p`（**故意写错**，用普通代码块） -/

--
-- theorem em0 (p : Prop) : p ∨ ¬p :=
--   Or.elim p (fun hp => Or.inl hp) (fun hnp => Or.inr hnp)
-- ↑ error: Application type mismatch: The argument
--     p
--   has type
--     Prop
--   of sort `Type` but is expected to have type
--     ?m.1 ∨ ?m.2
--   of sort `Prop` in the application
--     Or.elim p
--

-- 用 `Classical` 就一行
theorem em0 (p : Prop) : p ∨ ¬p := Classical.em p

/-! ## 3. 双重否定消去（原文例子） -/

theorem dne {p : Prop} (h : ¬¬p) : p :=
  Or.elim (em p)
    (fun hp : p => hp)
    (fun hnp : ¬p => absurd hnp h)

/-! ## 4. 分情况 `byCases`（证明项形式，不是 tactic） -/

example (h : ¬¬p) : p :=
  byCases
    (fun h1 : p => h1)
    (fun h1 : ¬p => absurd h1 h)

/-! ## 5. 反证 `byContradiction`（证明项形式） -/

example (h : ¬¬p) : p :=
  byContradiction
    (fun h1 : ¬p =>
     show False from h h1)

/-! ## 6. 真的需要经典：「不同时为真」推不出「哪个是假」 -/

variable (q : Prop)

theorem notBoth (h : ¬(p ∧ q)) : ¬p ∨ ¬q :=
  Or.elim (em p)
    (fun hp : p =>
      Or.inr
        (show ¬q from
          fun hq : q =>
          h ⟨hp, hq⟩))
    (fun hp : ¬p =>
      Or.inl hp)

/-! ## 7. 对照：**不用二选一**的方向，构造性就能证 -/

-- ⚠️ 这个文件**前面有 `open Classical`**，但这段证明**根本不需要它**：
-- 目标 `¬p ∧ ¬q` 要求**两个都给**，不用排中律。
-- （单独放一个没有 `open Classical` 的文件也能通过，见讲义 §6 的对照块）
example (h : ¬(p ∨ q)) : ¬p ∧ ¬q :=
  ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩

-- `#print` 看清楚：`dne` 展开后正是 `Or.elim (em p) …`（手写那三行）
#print dne
-- fun {p} h => Or.elim (em p) (fun hp => hp) fun hnp => absurd hnp h

#print notBoth
-- fun p q h => Or.elim (em p) (fun hp => Or.inr (have this := fun hq => h ⟨hp, hq⟩; this)) fun hp => Or.inl hp
