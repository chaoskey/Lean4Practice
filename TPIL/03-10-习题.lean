/-
  第 3 章 · 第 10 课 · 习题：命题逻辑收官（综合演练）

  这是**第 3 章最后一组习题**。18 道，覆盖原文 3.6 那张清单里
  你在 03-9 之后**还没做过**的全部条目。

  规则：
    · 全部 18 道：**写证明**（把 `sorry` 换掉）
    · 用**证明项**写，不要用 tactic（tactic 是第 5 章的内容，本课不引入）

  检查：
    lake env lean TPIL/03-10-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
  ⚠️ 本文件里**一处 `sorry` 都不能留**（讲义 §7）——
     而且交了还有 `sorry` 的话，`#print axioms` 会显示 `[sorryAx]`。

  📌 讲义 §2 那张「看到目标先看形状」的表，是今天最该反复看的东西。
-/

/- ============================================================
   一、交换律与结合律（题 1–4）
   ============================================================ -/

/- 题 1：合取的交换律。

    我的答案： -/
theorem ex1 (p q : Prop) : p ∧ q ↔ q ∧ p :=
  -- Iff.intro (
  --   -- p ∧ q → q ∧ p
  --   fun h : p ∧ q => show q ∧ p from (
  --     ⟨h.right, h.left⟩
  --   )
  -- ) (
  --   -- q ∧ p → p ∧ q
  --   fun h : q ∧ p => show p ∧ q from (
  --     ⟨h.right, h.left⟩
  --   )
  -- )
  Iff.intro
    (fun h => ⟨h.right, h.left⟩)
    (fun h => ⟨h.right, h.left⟩)

/- 题 2：析取的交换律。

    提示：⚠️ 这条特别容易把 `Or.inl` / `Or.inr` 拿反——
          每写一个就问「它要的是不是我要喂的那一边」。
    提示：讲义 §2 的例 B 演示的是**箭头**形式，本题要写成 `↔`。

    我的答案： -/
theorem ex2 (p q : Prop) : p ∨ q ↔ q ∨ p :=
  -- Iff.intro (
  --   -- p ∨ q → q ∨ p
  --   fun h : p ∨ q => show q ∨ p from (
  --     Or.elim h (
  --       fun hp : p => Or.inr hp
  --     ) (
  --       fun hq : q => Or.inl hq
  --     )
  --   )
  -- ) (
  --   -- q ∨ p → p ∨ q
  --   fun h : q ∨ p => show p ∨ q from (
  --     Or.elim h (
  --       fun hq : q => Or.inr hq
  --     ) (
  --       fun hp : p => Or.inl hp
  --     )
  --   )
  -- )
    Iff.intro (
      fun h =>  Or.elim h
        (fun hp => Or.inr hp)
        (fun hq => Or.inl hq)
    ) (
      fun h => Or.elim h
        (fun hq => Or.inr hq)
        (fun hp => Or.inl hp)
    )

/- 题 3：合取的结合律。

    我的答案： -/
theorem ex3 (p q r : Prop) : (p ∧ q) ∧ r ↔ p ∧ (q ∧ r) :=
  -- Iff.intro (
  --   -- (p ∧ q) ∧ r → p ∧ (q ∧ r)
  --   fun h : (p ∧ q) ∧ r => show p ∧ (q ∧ r) from (
  --     ⟨h.left.left, ⟨h.left.right, h.right⟩⟩
  --   )
  -- ) (
  --   -- p ∧ (q ∧ r) → (p ∧ q) ∧ r
  --   fun h : p ∧ (q ∧ r) => show (p ∧ q) ∧ r from (
  --     ⟨⟨h.left, h.right.left⟩, h.right.right⟩
  --   )
  -- )
  Iff.intro
    (fun h => ⟨h.left.left, ⟨h.left.right, h.right⟩⟩)
    (fun h => ⟨⟨h.left, h.right.left⟩, h.right.right⟩)

/- 题 4：析取的结合律。

    ⚠️ 这条比题 3 难：右边是「两个 `∨` 套起来」，
       分支上可能要**连续**做两次析取消去。
    提示：注意目标换了一层之后，`inl` / `inr` 该用哪个也变了。

    我的答案： -/
theorem ex4 (p q r : Prop) : (p ∨ q) ∨ r ↔ p ∨ (q ∨ r) :=
  -- Iff.intro (
  --   -- (p ∨ q) ∨ r → p ∨ (q ∨ r)
  --   fun h : (p ∨ q) ∨ r => show p ∨ (q ∨ r) from (
  --     Or.elim h (
  --       -- p ∨ q → p ∨ (q ∨ r)
  --       fun hpq : p ∨ q => show p ∨ (q ∨ r) from (
  --         Or.elim hpq (
  --           -- p → p ∨ (q ∨ r)
  --           fun hp : p => Or.inl hp
  --         ) (
  --           -- q → p ∨ (q ∨ r)
  --           fun hq : q => Or.inr (Or.inl hq)
  --         )
  --       )
  --     ) (
  --       -- r → p ∨ (q ∨ r)
  --       fun hr : r => show p ∨ (q ∨ r) from (
  --         Or.inr (Or.inr hr)
  --       )
  --     )
  --   )
  -- ) (
  --   -- p ∨ (q ∨ r) → (p ∨ q) ∨ r
  --   fun h : p ∨ (q ∨ r) => show (p ∨ q) ∨ r from (
  --     Or.elim h (
  --       -- p → (p ∨ q) ∨ r
  --       fun hp : p => Or.inl (Or.inl hp)
  --     ) (
  --       -- q ∨ r → (p ∨ q) ∨ r
  --       fun hqr : q ∨ r => show (p ∨ q) ∨ r from (
  --         Or.elim hqr (
  --           -- q → (p ∨ q) ∨ r
  --           fun hq : q => Or.inl (Or.inr hq)
  --         ) (
  --           -- r → (p ∨ q) ∨ r
  --           fun hr : r => Or.inr hr
  --         )
  --       )
  --     )
  --   )
  -- )
  Iff.intro (
    fun h => Or.elim h (
        fun hpq => Or.elim hpq
            (fun hp => Or.inl hp)
            (fun hq => Or.inr (Or.inl hq))
      ) (
        fun hr => Or.inr (Or.inr hr)
      )
  ) (
    fun h => Or.elim h (
        fun hp => Or.inl (Or.inl hp)
      ) (
        fun hqr => Or.elim hqr
            (fun hq => Or.inl (Or.inr hq))
            (fun hr => Or.inr hr)
      )
  )

/- ============================================================
   二、分配律与它的兄弟（题 5–6）
   ============================================================ -/

/- 题 5：合取对析取的分配律。

    我的答案： -/
theorem ex5 (p q r : Prop) : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) :=
  -- Iff.intro (
  --   -- p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r)
  --   fun h : p ∧ (q ∨ r) => show (p ∧ q) ∨ (p ∧ r) from (
  --     Or.elim h.right (
  --       -- q → (p ∧ q) ∨ (p ∧ r)
  --       fun hq :q => show (p ∧ q) ∨ (p ∧ r) from (
  --         Or.inl ⟨h.left, hq⟩
  --       )
  --     ) (
  --       -- r → (p ∧ q) ∨ (p ∧ r)
  --       fun hr : r => show (p ∧ q) ∨ (p ∧ r) from (
  --         Or.inr ⟨h.left, hr⟩
  --       )
  --     )
  --   )
  -- ) (
  --   -- (p ∧ q) ∨ (p ∧ r) → p ∧ (q ∨ r)
  --   fun h : (p ∧ q) ∨ (p ∧ r) => show p ∧ (q ∨ r) from (
  --     Or.elim h (
  --       -- p ∧ q → p ∧ (q ∨ r)
  --       fun hpq : p ∧ q => show p ∧ (q ∨ r) from (
  --         ⟨hpq.left, Or.inl hpq.right⟩
  --       )
  --     ) (
  --       -- p ∧ r → p ∧ (q ∨ r)
  --       fun hpr : p ∧ r => show p ∧ (q ∨ r) from (
  --         ⟨hpr.left, Or.inr hpr.right⟩
  --       )
  --     )
  --   )
  -- )
  Iff.intro (
    fun h => Or.elim h.right
      (fun hq => Or.inl ⟨h.left, hq⟩)
      (fun hr => Or.inr ⟨h.left, hr⟩)
  ) (
    fun h => Or.elim h
      (fun hpq => ⟨hpq.left, Or.inl hpq.right⟩)
      (fun hpr => ⟨hpr.left, Or.inr hpr.right⟩)
  )

/- 题 6：析取「吃」一个蕴含。

    我的答案： -/
theorem ex6 (p q r : Prop) : ((p ∨ q) → r) ↔ (p → r) ∧ (q → r) :=
  -- Iff.intro (
  --   -- ((p ∨ q) → r) → (p → r) ∧ (q → r)
  --   fun h : (p ∨ q) → r => show (p → r) ∧ (q → r) from (
  --     ⟨
  --       fun hp : p => h (Or.inl hp)
  --       ,
  --       fun hq : q => h (Or.inr hq)
  --     ⟩
  --   )
  -- ) (
  --   -- (p → r) ∧ (q → r) → ((p ∨ q) → r)
  --   fun h : (p → r) ∧ (q → r) => show (p ∨ q) → r from (
  --     fun hpq : p ∨ q => show r from (
  --       Or.elim hpq (
  --         -- p → r
  --         fun hp : p => h.left hp
  --       ) (
  --         -- q → r
  --         fun hq : q => h.right hq
  --       )
  --     )
  --   )
  -- )
  Iff.intro (
    fun h => ⟨fun hp => h (Or.inl hp),fun hq => h (Or.inr hq)⟩
  ) (
    fun h => fun hpq => Or.elim hpq
        (fun hp : p => h.left hp)
        (fun hq : q => h.right hq)
  )

/- ============================================================
   三、否定、矛盾与单位（题 7–13）
   ============================================================ -/

/- 题 7：

    我的答案： -/
theorem ex7 (p q : Prop) : ¬p ∨ ¬q → ¬(p ∧ q) :=
  -- fun h : ¬p ∨ ¬q => show ¬(p ∧ q) from (
  --   fun hpq : p ∧ q => show False from (
  --     Or.elim h (
  --       -- ¬p → False
  --       fun hnp : ¬p => show False from (
  --         hnp hpq.left
  --       )
  --     ) (
  --       -- ¬q → False
  --       fun hnq : ¬q => show False from (
  --         hnq hpq.right
  --       )
  --     )
  --   )
  -- )
  fun h => fun hpq => Or.elim h
        (fun hnp => hnp hpq.left)
        (fun hnq => hnq hpq.right)

/- 题 8：

    我的答案： -/
theorem ex8 (p : Prop) : ¬(p ∧ ¬p) :=
  -- fun hpq : p ∧ ¬p => show False from (
  --   hpq.right hpq.left
  -- )
  fun hpq => hpq.right hpq.left

/- 题 9：

    我的答案： -/
theorem ex9 (p q : Prop) : p ∧ ¬q → ¬(p → q) :=
  -- fun h : p ∧ ¬q => show ¬(p → q) from (
  --   fun hpq : p → q => show False from (
  --     h.right (hpq h.left)
  --   )
  -- )
  fun h => fun hpq => h.right (hpq h.left)

/- 题 10：这条的右边是**一个函数**。

    我的答案： -/
theorem ex10 (p q : Prop) : ¬p → (p → q) :=
  -- fun hnp : ¬p => fun hp : p => show q from (absurd hp hnp) -- (False.elim (hnp hp))
  fun hnp => fun hp => absurd hp hnp -- False.elim (hnp hp)

/- 题 11：

    我的答案： -/
theorem ex11 (p : Prop) : p ∨ False ↔ p :=
  -- Iff.intro (
  --   -- (p ∨ False) →  p
  --   fun h : p ∨ False => show p from (
  --     Or.elim h (
  --       -- p → p
  --       fun hp : p => hp
  --     ) (
  --       -- False → p
  --       fun f : False => False.elim f
  --     )
  --   )
  -- ) (
  --   -- p → (p ∨ False)
  --   fun hp : p => show p ∨ False from (
  --     Or.inl hp
  --   )
  -- )
  Iff.intro (
    fun h => Or.elim h
      (fun hp => hp)
      (fun f => False.elim f)
  ) (
    fun hp => Or.inl hp
  )

/- 题 12：⚠️ 这条右边**没有** `p`。
          想想：手上拿着 `False` 时能交出什么。

    我的答案： -/
theorem ex12 (p : Prop) : p ∧ False ↔ False :=
  -- Iff.intro (
  --   -- p ∧ False → False
  --   fun h : p ∧ False => show False from (
  --     h.right
  --   )
  -- ) (
  --   -- False → p ∧ False
  --   fun f : False => show p ∧ False from (
  --     False.elim f
  --   )
  -- )
  Iff.intro
    (fun h => h.right)
    (fun f => False.elim f)

/- 题 13：⚠️ 这条**没有假设**，要凭空造出 `False`。
          提示：先从 `h.mp` 和 `h.mpr` 各造出一个**函数**，
                再看这两个函数能不能自己撞起来。

    我的答案： -/
theorem ex13 (p : Prop) : ¬(p ↔ ¬p) :=
  -- -- 无 let 版本
  -- fun H : p ↔ ¬p => show False from  (
  --   (fun h : p => show False from H.mp h h) (H.mpr (fun h : p => show False from H.mp h h))
  -- )
  -- -- 有 let 版本
  -- fun H : p ↔ ¬p => show False from  (
  --   let f : ¬p := fun h : p => show False from H.mp h h
  --   -- ¬p p → False
  --   f (H.mpr f)
  -- )
-- 有 let 版本
  fun H =>
    let f := fun h => H.mp h h
    f (H.mpr f)

/- ============================================================
   四、需要经典的一组（题 14–18）
   ============================================================ -/

/- 这一组每一条都绕不开经典。

    ⚠️ **用哪个工具、写在哪里、要不要 `open`——这部分就是题目本身。**
    📌 交题时用 `#print axioms` 核对：这一组**应该**带上公理。
       如果某一条你居然做出了零公理的版本，**先别急着高兴**——
       那要么是这条其实不需要经典（值得和讲义 §4.2 讨论），
       要么是你的证明里藏了 `sorry`（查 `[sorryAx]`）。

-/

open Classical

/- 题 14：⚠️ 目标里有两个析取，包着一个「或」的结论。
          提示：先看**手上**有什么，再决定要不要经典——
                手上如果已经有材料，往往就不用。

    我的答案： -/
theorem ex14 (p r s : Prop) : (p → r ∨ s) → ((p → r) ∨ (p → s)) :=
  -- fun h : (p → (r ∨ s)) => show (p → r) ∨ (p → s) from (
  --   Or.elim (em p) (
  --     -- p → (p → r) ∨ (p → s)
  --     fun hp : p => show (p → r) ∨ (p → s) from (
  --       Or.elim (h hp) (
  --         -- r → (p → r) ∨ (p → s)
  --         fun hr : r => Or.inl (fun _ : p => hr)
  --       ) (
  --         -- s → (p → r) ∨ (p → s)
  --         fun hs : s => Or.inr (fun _ : p => hs)
  --       )
  --     )
  --   ) (
  --     -- ¬p → (p → r) ∨ (p → s)
  --     fun hnp : ¬p => show (p → r) ∨ (p → s) from (
  --       -- 辣鸡分支，炸掉
  --       Or.inl (fun hp : p => show r from False.elim (hnp hp))
  --     )
  --   )
  -- )
  fun h => Or.elim (em p) (
      fun hp => Or.elim (h hp)
          (fun hr => Or.inl (fun _ => hr))
          (fun hs => Or.inr (fun _ : p => hs))
    ) (
      fun hnp => Or.inl (fun hp => False.elim (hnp hp))
    )

/- 题 15：

    我的答案： -/
theorem ex15 (p q : Prop) : ¬(p ∧ q) → ¬p ∨ ¬q :=
  -- fun h : ¬(p ∧ q) => show ¬p ∨ ¬q from (
  --   Or.elim (em p) (
  --     -- p → ¬p ∨ ¬q
  --     fun hp : p => show ¬p ∨ ¬q from (
  --       Or.inr (fun hq : q => h ⟨hp, hq⟩)
  --     )
  --   ) (
  --     -- ¬p → ¬p ∨ ¬q
  --     fun hnp : ¬p => show ¬p ∨ ¬q from (
  --       Or.inl hnp
  --     )
  --   )
  -- )
  fun h => Or.elim (em p)
    (fun hp => Or.inr (fun hq : q => h ⟨hp, hq⟩))
    (fun hnp => Or.inl hnp)

/- 题 16：

    我的答案： -/
theorem ex16 (p q : Prop) : ¬(p → q) → p ∧ ¬q :=
-- -- 这里用到了经典：对 p 进行分类讨论
--   fun h : ¬(p → q) => show p ∧ ¬q from (
--     Or.elim (em p) (
--       -- p → p ∧ ¬q
--       fun hp : p => show p ∧ ¬q from (
--         ⟨
--           hp,
--           show ¬q from (
--             fun hq : q => show False from (
--               h (
--                 -- p → q
--                 fun _ : p => hq
--               )
--             )
--           )
--         ⟩
--       )
--     ) (
--       -- ¬p → p ∧ ¬q
--       fun hnp : ¬p => False.elim (h (fun hp : p => False.elim (hnp hp)))
--       -- fun hnp : ¬p => show p ∧ ¬q from (
--       --   ⟨
--       --     sorry,
--       --     fun hq : q => show False from (
--       --       h (fun _ : p => hq)
--       --     )
--       --   ⟩
--       -- )
--     )
--   )
-- -- 更简单的方法
-- fun h : ¬(p → q) =>  show p ∧ ¬q from
--     ⟨
--       byContradiction (
--         fun hnp : ¬p => h (fun hp : p => False.elim (hnp hp))
--       )
--       ,
--       fun hq : q => h (fun _ : p => hq)
--     ⟩
fun h =>
    ⟨
      byContradiction (fun hnp => h (fun hp => False.elim (hnp hp)))
      ,
      fun hq => h (fun _ => hq)
    ⟩

/- 题 17：

    我的答案： -/
theorem ex17 (p : Prop) : p ∨ ¬p :=
  -- byCases (p := p) (
  --   -- p → p ∨ ¬p
  --   fun hp : p => Or.inl hp
  -- ) (
  --   -- ¬p → p ∨ ¬p
  --   fun hnp : ¬p => Or.inr hnp
  -- )
  byCases
    (fun hp => Or.inl hp)
    (fun hnp => Or.inr hnp)

/- 题 18：⚠️ 目标**最外层**是一层函数，参数本身又是一层函数。
          注意数一数：这里要吃几个 `fun`。

    我的答案： -/
theorem ex18 (p q : Prop) : ((p → q) → p) → p :=
  -- -- 我的原始的毕竟绕的方法  对 p → q 进行分类讨论
  -- fun h : (p → q) → p => show p from (
  --   Or.elim (em (p → q)) (
  --     -- (p → q) → p
  --     fun h1 : (p → q) => show p from (
  --       h h1
  --     )
  --   ) (
  --     -- ¬(p → q) → p
  --     fun h2 : (p → q) → False => show p from (
  --       byContradiction (
  --         fun hnp : ¬p => show False from (
  --           h2 (fun hp : p => False.elim (hnp hp))
  --         )
  --       )
  --     )
  --   )
  -- )
  -- -- 直接对 p 进行分类讨论
  -- fun h : (p → q) → p => show p from (
  --   Or.elim (em p)
  --     (
  --       -- p → p
  --       fun hp : p => show p from hp
  --     ) (
  --       -- ¬p → p
  --       fun hnp : ¬p => show p from (
  --         h (fun hp : p => show q from False.elim (hnp hp))
  --       )
  --     )
  -- )
  fun h => Or.elim (em p)
      (fun hp => hp)
      (fun hnp => h (fun hp => False.elim (hnp hp)))


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- 逐题查公理：把下面这行取消注释，然后把你关心的名字一个个填上去。
#print axioms ex1 -- 'ex1' does not depend on any axioms
#print axioms ex2 -- 'ex2' does not depend on any axioms
#print axioms ex3 -- 'ex3' does not depend on any axioms
#print axioms ex4 -- 'ex4' does not depend on any axioms
#print axioms ex5 -- 'ex5' does not depend on any axioms
#print axioms ex6 -- 'ex6' does not depend on any axioms
#print axioms ex7 -- 'ex7' does not depend on any axioms
#print axioms ex8 -- 'ex8' does not depend on any axioms
#print axioms ex9 -- 'ex9' does not depend on any axioms
#print axioms ex10 -- 'ex10' does not depend on any axioms
#print axioms ex11 -- 'ex11' does not depend on any axioms
#print axioms ex12 -- 'ex12' does not depend on any axioms
#print axioms ex15 -- 'ex15' depends on axioms: [propext, choice, Quot.sound]
#print axioms ex16 -- 'ex16' depends on axioms: [propext, choice, Quot.sound]
#print axioms ex17 -- 'ex17' depends on axioms: [classical.choice]
#print axioms ex18 -- 'ex18' depends on axioms: [classical.choice]
--
-- 对照实验（想验证「工具会带来公理」时用）：
-- 先写一个**不用**经典的小定理，再写一个**用了**经典的，
-- 分别查它们的公理，比对两行输出。

#print axioms ex13 -- 'ex13' does not depend on any axioms
#print axioms ex14 -- 'ex14' depends on axioms: [propext, choice, Quot.sound]
