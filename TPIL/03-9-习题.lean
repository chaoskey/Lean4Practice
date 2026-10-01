/-
  第 3 章 · 第 9 课 · 习题：命题有效性的综合演练

  规则：
    · 题 1–6：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 题 7–8：把**你的判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-9-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
  ⚠️ 本文件里**一处 `sorry` 都不能留**（讲义 §4.3）——
     而且交了还有 `sorry` 的话，`#print axioms` 会显示 `[sorryAx]`。

  💡 提示：本课**有些题可能需要你引入经典逻辑**。用哪个工具、写在哪里、
     要不要写 `open`——**这部分是题目本身**，讲义 §7.4 与 §8 讲过怎么判断。
-/

/- ============ 一、写六个证明 ============ -/

/- 题 1：**分配律的孪生**——把样板一里的 `∧` 和 `∨` 对调。

    约束：用**证明项**写。
    提示：讲义 §6（样板一）的每一步都能对上，只是「哪一半用 `Or.inl`、
          哪一半用 `Or.inr`」要重新想一遍——**这正是本题要练的**。

    我的答案： -/
theorem ex1 (p q r : Prop) : p ∨ (q ∧ r) ↔ (p ∨ q) ∧ (p ∨ r) :=
  Iff.intro (
    -- p ∨ (q ∧ r) →  (p ∨ q) ∧ (p ∨ r)
    fun h : p ∨ (q ∧ r) => show (p ∨ q) ∧ (p ∨ r) from (
      -- 对 h 进行分情况讨论
      Or.elim h (
        -- p → (p ∨ q) ∧ (p ∨ r)
        fun hp : p => show (p ∨ q) ∧ (p ∨ r) from (
          ⟨Or.inl hp, Or.inl hp⟩
        )
      ) (
        -- q ∧ r → (p ∨ q) ∧ (p ∨ r)
        fun hqr : q ∧ r => show (p ∨ q) ∧ (p ∨ r) from (
          ⟨Or.inr hqr.left, Or.inr hqr.right⟩
        )
      )
    )
  ) (
    -- (p ∨ q) ∧ (p ∨ r) → p ∨ (q ∧ r)
    fun h : (p ∨ q) ∧ (p ∨ r) => show p ∨ (q ∧ r) from (
      -- 对 p ∨ q 分
      Or.elim h.left (
        -- p → p ∨ (q ∧ r)
        fun hp : p => Or.inl hp
      ) (
        -- q → p ∨ (q ∧ r)
        fun hq : q => show p ∨ (q ∧ r) from (
          -- 对 p ∨ r 分
          Or.elim h.right (
            fun hp : p => Or.inl hp
          ) (
            fun hr : r => Or.inr ⟨hq, hr⟩
          )
          )
      )
    )
  )
  -- Iff.intro
  -- (
  --   fun h => Or.elim h  -- 对 h 分
  --       (fun hp => ⟨Or.inl hp, Or.inl hp⟩)
  --       (fun hqr => ⟨Or.inr hqr.left, Or.inr hqr.right⟩)
  -- )
  -- (
  --   fun h => Or.elim h.left -- 对 p ∨ q 分
  --     (fun hp => Or.inl hp)
  --     (
  --       fun hq => Or.elim h.right -- 对 p ∨ r 分
  --           (fun hp => Or.inl hp)
  --           (fun hr => Or.inr ⟨hq, hr⟩)
  --     )
  -- )

/- 题 2：把「两层蕴含」和「合取当条件」绑成等价。

    约束：用**证明项**写。
    提示：两个方向各是一个**函数**。想清楚「我手上拿到什么、要交出什么」，
          再决定每个方向要不要 `fun`。

    我的答案： -/
theorem ex2 (p q r : Prop) : (p → (q → r)) ↔ (p ∧ q → r) :=
  Iff.intro (
    --  (p → (q → r)) → (p ∧ q → r)
    fun h : p →  (q → r) => show p ∧ q → r from (
      fun hpq : p ∧ q => (
        h hpq.left hpq.right
      )
    )
  ) (
    --  (p ∧ q → r) → (p → (q → r))
    fun h : (p ∧ q → r) => show p → (q → r) from (
      fun (hp : p) (hq : q) => (
        h ⟨hp, hq⟩
      )
    )
  )
  -- Iff.intro
  --   (fun h => fun hpq : p ∧ q => h hpq.left hpq.right)
  --   (fun h => fun hp hq => h ⟨hp, hq⟩)


/- 题 3：德摩根律的**一半**。

    约束：用**证明项**写。
    提示：两个方向形状完全不同——
          一个方向是「从否定推出合取」；另一个方向是「从合取推出否定」。
          后者要**分情况**（手上有析取）。

    我的答案： -/
theorem ex3 (p q : Prop) : ¬(p ∨ q) ↔ ¬p ∧ ¬q :=
  Iff.intro (
    -- ¬(p ∨ q) → ¬p ∧ ¬q
    fun h : ¬(p ∨ q) => show ¬p ∧ ¬q from (
      ⟨
        -- 构造 ¬p
        fun hp : p => show False from (
          h (Or.inl hp)
        )
        ,
        -- 构造 ¬q
        fun hq : q => show False from  (
          h (Or.inr hq)
        )
      ⟩
    )
  ) (
    -- ¬p ∧ ¬q → ¬(p ∨ q)
    fun h : ¬p ∧ ¬q => show ¬(p ∨ q) from (
      fun hpq : p ∨ q => show False from (
        Or.elim hpq (
          -- p → False
          fun hp : p => show False from (h.left hp)
        ) (
          -- q → False
          fun hq : q => show False from (h.right hq)
        )
      )
    )
  )
  -- Iff.intro (
  --   fun h =>
  --     ⟨
  --       fun hp => h (Or.inl hp),
  --       fun hq =>  h (Or.inr hq)
  --     ⟩
  -- ) (
  --   fun h => fun hpq => Or.elim hpq
  --         (fun hp => h.left hp)
  --         (fun hq => h.right hq)
  -- )


/- 题 4：**逆否**。

    约束：用**证明项**写。
    提示：目标整体是**两层函数**——先想清楚「哪一层拿什么」。

    我的答案： -/
theorem ex4 (p q : Prop) : (p → q) → (¬q → ¬p) :=
  fun h : p → q => show (¬q → ¬p) from (
    fun hnq : ¬q => show ¬p from (
      fun hp : p => show False from (
        hnq (h hp)
      )
    )
  )
  -- fun h => fun hnq => fun hp => hnq (h hp)


/- 题 5：把题 4 的**方向反过来**。

    约束：用**证明项**写。
    提示：⚠️ 先自己动手，**卡住了再回头看讲义 §7**（那一节拆的就是
          「手上缺一个真值时怎么办」）。本题与题 4 是**对着的一对**——
          写完请自己看：**它们差在哪一步？**

    我的答案： -/
open Classical
-- #check byCases
-- Classical.byCases {p q : Prop} (hpq : p → q) (hnpq : ¬p → q) : q
theorem ex5 (p q : Prop) : (¬q → ¬p) → (p → q) :=
  fun h : ¬q → ¬p => show (p → q) from (
    fun hp : p => show q from (
      byContradiction (
        -- ¬q → False
        fun hnq : ¬q => show False from (
          h hnq hp
        )
      )
    )
  )
  -- fun h => fun hp => byContradiction (fun hnq => h hnq hp)

/- 题 6：把蕴含拆成析取。

    约束：用**证明项**写。
    提示：左边是 `p → q`，右边要交出一个**析取**。手上的 `h : p → q`
          不能直接变成析取——想清楚「缺什么信息」。

    我的答案： -/
theorem ex6 (p q : Prop) : (p → q) → (¬p ∨ q) :=
  fun h : p → q => show (¬p ∨ q) from (
    byCases (
      -- p → (¬p ∨ q)
      fun hp : p => show (¬p ∨ q) from (
        Or.inr (h hp)
      )
    ) (
      -- ¬p → (¬p ∨ q)
      fun hnp : ¬p => show (¬p ∨ q) from (
        Or.inl hnp
      )
    )
  )
  -- fun h  => byCases
  --   (fun hp => Or.inr (h hp))
  --   (fun hnp => Or.inl hnp)



/- ============ 二、判断 ============ -/

/- 题 7：题 4、题 5、题 6 这三条里，**哪些需要经典逻辑**？

    要求：
      ① 先**自己判断**（不要在文件里跑命令之前就改答案）；
      ② 写出**你的判断依据**（一句话说清「为什么某条需要 / 不需要」）；
      ③ 然后**用 `#print axioms` 核对**——把每一条的实际输出抄在下面。

    ⚠️ 「依据」不能只写「我试了能编译」——讲义 §8.1 讲过为什么
        「能编译」不能当判据。

    我的答案：① 其中第 4 题不需要经典逻辑，第 5 第 6 题需要。
            ② 第 4 题可以用构造性逻辑证明，第 5 第 6 题需要用反证法或排中律。
            ③
            'ex4' does not depend on any axioms
            'ex5' depends on axioms: [propext, choice, Quot.sound]
            'ex6' depends on axioms: [propext, choice, Quot.sound]
 -/


/- 题 8：关于 `sorry` 和 `_` 的四个判断。

    ① 一个定理的证明里用了 `sorry`，`#print axioms` 会显示什么？
    ② 一个定理的证明里用了 `_` 并且**编译通过了**，`#print axioms` 会显示什么？
    ③ `example (p : Prop) (h : p) : p := _` 能不能通过？如果不能，报错的关键句是什么？
    ④ `_` 既然经常失败，那它有什么用？

    我的答案：① 会显示  sorryAx
      ② 会显示  sorryAx
      ③ 不能通过，报错的关键句是 " error: don't know how to synthesize placeholder"。
      ④ `_` 可以用作占位符，方便先写结构再补充具体证明。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- 题 7 的实验（一条一条跑，把输出抄到题 7 的答案里）：
#print axioms ex4
#print axioms ex5
#print axioms ex6
--
-- 题 8 ③ 的实验（这一段**会报错**，故意的）：
-- example (p : Prop) (h : p) : p := _ -- error: don't know how to synthesize placeholder
--
-- 题 8 ①② 的实验：自己写两个小定理各试一次（一个用 sorry、一个用 _）
-- theorem ex6_test (p q : Prop) : (p → q) → (¬p ∨ q) :=
--   fun h : p → q => show (¬p ∨ q) from (
--     byCases (p := p) (
--       sorry
--     ) (
--       sorry
--     )
--   )

-- theorem ex5_test (p q : Prop) : (¬q → ¬p) → (p → q) :=
--   fun h : ¬q → ¬p => show _ from (
--     fun hp : p => show q from (
--       byContradiction (
--         _
--       )
--     )
--   )
