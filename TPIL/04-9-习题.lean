/-
  第 4 章 · 第 9 课 · 习题：**收官**——章末习题演练

  规则：
    · 题 1、2、3、5：**写证明**；题 6：**写定义 ＋ 写证明**
      —— 全部**用证明项，不要用 tactic**（`fun` / `Iff.intro` / `Or.elim` / `Exists.*` / `calc` / 匿名 `have`）
    · 题 4：**说理**（要给出**反例**，做法见讲义 §4）
    · 题 7 是**可选**的：⚠️ 它**必须**用经典（`Classical.em`，是**项**不是 tactic）；
      它**整段是注释**——想做就把 `-- ` 去掉再写；用它做完请顺手用 `#print axioms` 核对
    · 本文件里**一处 `sorry` 都不能留**（题 7 保持注释即可）

  检查：
    lake env lean TPIL/04-9-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
  ⚠️ **验收脚本的 ✅ 只覆盖题 1、2、3、5、6**——题 4 的说理写在注释里，
     题 7 整段是注释，这两道由批改时人工核对。
-/

variable (α : Type) (p q : α → Prop) (r : Prop)

/- ============================================================
   题 1：`∀` 与 `∧` 的分配律（**两个方向都要**）。
   ============================================================ -/

/- 要证：`(∀ x, p x ∧ q x) ↔ (∀ x, p x) ∧ (∀ x, q x)`。

   提示：目标是 `↔`（讲义 §3.1）；两个方向各是一个 `fun`。
         · `→` 方向：手上是 `∀ x, p x ∧ q x`，怎么分别拿到 `∀ x, p x` 与 `∀ x, q x`？
         · `←` 方向：手上是 `(∀ x, p x) ∧ (∀ x, q x)`，目标却带 `∀ x`——先写 `fun x`（§3.2）。

   我的答案： -/
theorem ex1 : (∀ x, p x ∧ q x) ↔ (∀ x, p x) ∧ (∀ x, q x) :=
--   Iff.intro (
--    -- (∀ x, p x ∧ q x) → ((∀ x, p x) ∧ (∀ x, q x))
--    fun h : (∀ x, p x ∧ q x) => show (∀ x, p x) ∧ (∀ x, q x) from (
--       ⟨
--          fun x => (h x).left
--          ,
--          fun x => (h x).right
--       ⟩
--    )
--   ) (
--    -- ((∀ x, p x) ∧ (∀ x, q x)) → (∀ x, p x ∧ q x)
--    fun h : (∀ x, p x) ∧ (∀ x, q x) => show ∀ x, p x ∧ q x from (
--       fun x => ⟨h.left x, h.right x⟩
--    )
--   )
  Iff.intro
   (fun h => ⟨fun x => (h x).left, fun x => (h x).right⟩)
   (fun h => (fun x => ⟨h.left x, h.right x⟩))


/- ============================================================
   题 2：`∀` 底下的「肯定前件」。
   ============================================================ -/

/- 要证：`(∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x)`。

   提示：目标右边带 `∀ x`——先写 `fun x`；两条假设都是 `∀`，用它们的办法是**给一个具体的 `x`**（§3.2）。

   我的答案： -/
theorem ex2 : (∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x) :=
--   fun (h1 : (∀ x, p x → q x)) (h2 : (∀ x, p x)) => show (∀ x, q x) from (
--    fun x => h1 x (h2 x)
--   )
  fun h1 h2 => (fun x => h1 x (h2 x))


/- ============================================================
   题 3：`∨` 在 `∀` **里面**时，把「整体成立」摊到「每个都成立」。
   ============================================================ -/

/- 要证：`(∀ x, p x) ∨ (∀ x, q x) → ∀ x, p x ∨ q x`。

   提示：手上那条是 `∨`——用 `Or.elim` 分两种情况（§3.3，**不是** `byCases`）；
         每种情况里，答案选 `Or.inl` 还是 `Or.inr`，看目标那一侧。

   我的答案： -/
theorem ex3 : (∀ x, p x) ∨ (∀ x, q x) → ∀ x, p x ∨ q x :=
--   fun H : (∀ x, p x) ∨ (∀ x, q x) => show ∀ x, p x ∨ q x from (
--    Or.elim H (
--       fun h : (∀ x, p x) => fun x => Or.inl (h x)
--    ) (
--       fun h : (∀ x, q x) => fun x => Or.inr (h x)
--    )
--   )
  fun H => Or.elim H
   (fun h x => Or.inl (h x))
   (fun h x => Or.inr (h x))


/- ============================================================
   题 4：**说理**——上面那题的反方向为什么不成立？
   ============================================================ -/

/- 题 3 是 `(∀ x, p x) ∨ (∀ x, q x) → ∀ x, p x ∨ q x`。
   它的**反方向** `∀ x, p x ∨ q x → (∀ x, p x) ∨ (∀ x, q x)` **推不出来**。

   请给出一个**反例**说清这件事。讲义 §4 讲了标准做法，要点是：
     (1) 挑一个具体的类型 `α`、具体的 `p`、`q`；
     (2) 说明**右边**（题型 3 的左边那半、也就是 `∀ x, p x ∨ q x`）**成立**；
     (3) 说明**另一边****不成立**。

   ⚠️ 说「推不出来」**不能**只说「我试了没试出来」——那是「我的写法不行」，不是「不存在这样的证明」。

    我的反例：
    (1) 取 α := Bool，p x := x = true，q x := x = false
    (2) 为什么 `∀ x, p x ∨ q x` 成立：因为对任意 `x : Bool`，要么 `x = true`，要么 `x = false`，所以 `p x ∨ q x` 总成立。
    (3) 为什么 `(∀ x, p x) ∨ (∀ x, q x)` 不成立：因为 `∀ x, p x` 不成立（`x = false` 时 `p x` 不成立），`∀ x, q x` 也不成立（`x = true` 时 `q x` 不成立），所以它们的或也不成立。 -/


/- ============================================================
   题 5：⭐ **理发师悖论**（原文原题）。
   ============================================================ -/

/- 镇上有个（男）理发师：他**给且只给**那些**不给自己刮脸**的男人刮脸。
   要证：这件事**不可能**。

   已知：`h : ∀ x : men, shaves barber x ↔ ¬ shaves x x`
   要证：`False`

   提示：把 `h` **用在理发师本人身上**（`h barber`）——你就得到一条「`A ↔ ¬A`」式的等价；
         它两个方向各是什么？怎么用它逼出 `False`？
         （04-8 学的**匿名 `have`** 在这里会很好用。）

   ⚠️⚠️ **这一题是 AI 代做的**（2026-10-05：用户折腾很久仍做不出，明确要求破例；
      本项目的 D9 规矩是「AI **不得代做**」—— 破例的理由与后果见 `进度.md` 本课记录）。
      推理过程在讲义 / 批改回复里，这里只落代码。

   我的答案： -/
theorem ex5 (men : Type) (barber : men) (shaves : men → men → Prop)
    (h : ∀ x : men, shaves barber x ↔ ¬ shaves x x) : False :=
  -- 记 A := `shaves barber barber`（「理发师给自己刮脸」）。
  -- `h barber` 就是 `A ↔ ¬A`，两个方向分别是：
  --     (h barber).mp  : A → ¬A
  --     (h barber).mpr : ¬A → A
  -- 关键一步：先**假设 A**（就是那个 `fun hs => …`）——
  --   用 .mp 把 hs 变成 ¬A，再把这个 ¬A **喂回给 hs 本身** → False。
  --   所以这一整个 `fun` 就是「¬A」的证明（用 04-8 的匿名 have 存下来）。
--   have : ¬ shaves barber barber := fun hs => (h barber).mp hs hs
--   -- 有了 ¬A，用另一个方向 .mpr 把它变成 A；再把 ¬A 作用上去，就撞出 False。
--   this ((h barber).mpr this)
   let A := shaves barber barber
   have : ¬A := fun hs : A => show False from (h barber).mp hs hs
   this ((h barber).mpr this)

/- ============================================================
   题 6：写一个**只用 `∃`** 的定义，再用它做一次构造。
   ============================================================ -/

/- 原文 4.6 最后一组题是「写 `even` / `prime` / 「无穷多素数」/ `Fermat_prime` 的**定义**」——
   但那些要用 `∣`（整除）、`<`、`≤`、`^`，**本课程还没讲过**（讲义 §2 那张表写了原因）。
   所以这里**换一个只用 `∃` 的**：

   (1) 写出「**`n` 是 `d` 的倍数**」的定义，名字叫 `IsMultipleOf`：
       思路：`n` 是 `d` 的倍数，就是「**存在**某个 `k`，使 `n = d * k`」。
   (2) 然后**证明**「`6` 是 `3` 的倍数」，也就是 `IsMultipleOf 3 6`。
       提示：04-6 学的构造——**交一个见证 ＋ 一份证明**。

   我的答案（(1) 的定义）： -/
def IsMultipleOf (d n : Nat) : Prop :=
  ∃ k : Nat, n = d * k

/- 我的答案（(2) 的证明）： -/
theorem ex6 : IsMultipleOf 3 6 :=
  ⟨ 2, rfl ⟩



/- ============================================================
   题 7（**可选**）：必须用经典的那一边。
   ============================================================ -/

/- 要证：`(∀ x, p x ∨ r) → (∀ x, p x) ∨ r`。

   ⚠️ 这一边**必须用经典**——你需要判断 `r` 到底成不成立，那正是 `Classical.em r : r ∨ ¬r`。
   ⚠️ `Classical.em` 是**项**，所以本题仍然**不用任何 tactic**（讲义 §5 讲了怎么用）。
   ⚠️ 它是**限定名**——**不要**写 `open Classical`（那会静默影响整个文件，03-8 教过的坑）。

   (1) 写证明（把下面 `theorem ex7` 那两行的 `-- ` 去掉再写）；
   (2) 写完后用 `#print axioms ex7` 核对，**把实际输出抄在下面这行注释里**：

   我的答案（实际输出）： 'ex7' depends on axioms: [propext, Classical.choice, Quot.sound]

   我的答案（证明）： -/
theorem ex7 : (∀ x, p x ∨ r) → (∀ x, p x) ∨ r :=
--   fun h : (∀ x, p x ∨ r) => show (∀ x, p x) ∨ r from (
--    Or.elim (Classical.em r) (
--       fun hr : r => Or.inr hr
--    ) (
--       fun hnr : ¬r => Or.inl (fun x => (
--          Or.elim (h x) (
--             fun hp : p x => hp
--          ) (
--             fun hr : r => False.elim (hnr hr)
--          )
--       ))
--    )
--   )
  fun h => Or.elim (Classical.em r)
   (fun hr => Or.inr hr)
   (
      fun hnr => Or.inl (
         fun x => Or.elim (h x)
            (fun hp => hp)
            (fun hr => False.elim (hnr hr))
      )
   )



-- ============ 验证区（先自己写，写完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
--
-- ★ 题 4 的核对方法：
--   把下面那一行取消注释，跑一次检查命令：
--     · 它**应当通过**——这就是「左边是假的」的机器验证（讲义 §4 里那半步）
--   ⚠️ 核对完注不注回去都行——它是**独立的定理**，留着照样能编译 ✓
--      （本项目已完成的其他习题文件也普遍把核对行留着，见 `AGENTS.md` §6.20 补充）。
--   ⚠️ 别忘了另一半（「`Bool` 只有两个值，所以 `∀ x, x = true ∨ x = false` 成立」）
--      **机器验不了**：那要**分类讨论**，属**第 7 章**。所以它只能当「数学事实」用
--      ——这正是讲义 §4 说的「哪一层能实测、哪一层只能标数学事实，要写清楚」。
--
theorem ce_key (h : (∀ x : Bool, x = true) ∨ (∀ x : Bool, x = false)) : False :=
  h.elim (fun h1 => Bool.false_ne_true (h1 false))
         (fun h2 => Bool.false_ne_true (Eq.symm (h2 true)))
--
-- ★ 题 7（可选）的公理核对：等你做完题 7，把下面这行取消注释，对着 `#print axioms` 的输出看。
#print axioms ex7  -- 'ex7' depends on axioms: [propext, Classical.choice, Quot.sound]
--
-- 逐题查公理：把下面几行取消注释，然后跑检查命令，**逐行对着实际输出看**。
#print axioms ex1  -- 'ex1' does not depend on any axioms
#print axioms ex2  -- 'ex2' does not depend on any axioms
#print axioms ex3  -- 'ex3' does not depend on any axioms
#print axioms ex5  -- 'ex5' does not depend on any axioms
#print axioms ex6  -- 'ex6' does not depend on any axioms
