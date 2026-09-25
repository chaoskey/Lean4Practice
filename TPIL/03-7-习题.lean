/-
  第 3 章 · 第 7 课 · 习题：辅助子目标 `have` / `suffices`

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-7-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：已知 `h : p ∧ q` 和 `hr : q → r`，证明 `p ∧ r`。

    约束：**至少用一个 `have`**（不要一口气写成一行）。

    提示：目标 `p ∧ r` 要「**两样东西**」——`p` 你**手上就有**（在 `h` 里），
          `r` 要**先有 `q` 才能拿**。所以那个中间事实是什么？

    我的答案： -/
theorem ex1 (p q r : Prop) (h : p ∧ q) (hr : q → r) : p ∧ r :=
  have hq :q := h.right
  show p ∧ r from ⟨h.left, hr hq⟩

/- 题 2：已知 `h : p ∧ (q ∧ r)`，证明 `p ∧ (r ∧ q)`（**调换后两样**）。

    约束：用 `have` 起中间步骤，**先把内层那个「对」拆开**。

    提示：内层 `h.right` 本身**也是一个对**（`q ∧ r`）——所以拆它要用**两次**（03-3 学的）。
          ⚠️ 注意目标里的**顺序**：`r` 在前、`q` 在后。

    我的答案： -/
theorem ex2 (p q r : Prop) (h : p ∧ (q ∧ r)) : p ∧ (r ∧ q) :=
  have hrq : r ∧ q := ⟨ h.right.right, h.right.left⟩
  show p ∧ (r ∧ q) from ⟨h.left, hrq⟩

/- 题 3：已知 `h : (p ∧ q) ∧ r`，证明 `p ∧ (q ∧ r)`（**换个分组**）。

    约束：这一题**必须用 `suffices`**（不用 `have`）。

    提示：`suffices` 是**倒着想**——先写「**只要有了 X 就够**」，再写「X 怎么来」。
          ⚠️ 写 `suffices` 之前先问一句：「**我的目标，是只差哪一样东西？**」
          ⚠️ `suffices` 那一行的 `from` 后面写的是「**有了它之后怎么做出目标**」，
             **不是**「它从哪来」——这是最容易写反的地方。

    我的答案： -/
theorem ex3 (p q r : Prop) (h : (p ∧ q) ∧ r) : p ∧ (q ∧ r) :=
  suffices hqr : q ∧ r from ⟨h.left.left,hqr⟩
  show q ∧ r from ⟨h.left.right,h.right⟩


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`have h : p := s` 后面接上 `t`，整个证明项展开成**什么**？
          讲义 §3 说它**不是新语法**——请写出那个展开式（用 `fun` 和应用）。
          你的展开式**自己跑一遍能过吗**？

    我的答案：(fun h : p => t )s -/


/- 题 5：02-6 讲过的 `let`，**能不能**用在证明里？（能 / 不能）
          如果能，它和 `have` 的**差别**在哪（不是「能不能」，是「**读起来的意思**」）？

    我的答案：在证明中可以使用 `let`，但是用到它时，——只是读起来像是「先定义一个局部常量」，而不是「先断言一个中间事实」。 -/


/- 题 6：`suffices hq : q from E` 后面接上 `t`，**一共要完成几件事**？分别是什么？
          ⚠️ 另外：只写 `suffices hq : q` 就结束（不写后面），会得到**什么错**
          （**语法错**还是**类型错**）？

    我的答案：两件事：依然是先证明 `hq : q`，再用 `hq` 完成目标。   ⚠️ 如果只写 `suffices hq : q` 就结束，会得到语法错，因为 Lean 期待你给出 `from` 后的证明。 -/


/- 题 7：下面三个写**语法糖**的写法和「手动展开」是**同一个证明**吗**？** 请用讲义 §3 的方法回答：
          `theorem t1 (h : p ∧ q) : q ∧ p := have hp : p := h.left; have hq : q := h.right; show q ∧ p from And.intro hq hp`
          `#print t1` 打出来的是**哪一种**？（带 `have` 的，还是手动 `fun` 的？）
          ⚠️ 依据要给出**实测**（哪一行命令、打出什么），不要只写「应该一样」。

    我的答案：的确是同一个证明。`#print t1` 打出来的是带 have 的。 -/


/- 题 8：`show T from e` / `have h : p := e` / `suffices h : p from e`，
          三个**各自断言什么**？哪一个是「**倒着想**」的那个？
          ⚠️ 回答时请**分别写清「它断言了什么」**，不要用「都是组织证明的工具」这种笼统说法。

    我的答案：第一个是展示类型为 T 的一个证明 e 。第二个是展示一个中间证明 e ，然后用它作为后续的假设。第三个是倒着想，你要给出 h 就能得到 e。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- ⚠️ 讲义 §2、§4、§5 里那些**故意写错**的写法在**讲义/示例里**（不参与本文件的检查）。

variable (p q r : Prop)

-- 题 4 的展开实验（自己跑一遍）：
theorem u1 (h : p ∧ q) : q ∧ p :=
   (fun (hq : q) => (fun (hp : p) => And.intro hq hp) h.left) h.right
#print u1
-- theorem u1 : ∀ (p q : Prop), p ∧ q → q ∧ p :=
-- fun p q h => (fun hq => (fun hp => ⟨hq, hp⟩) h.left) h.right

-- 题 7 的 #print（自己跑一遍）：
theorem v1 (h : p ∧ q) : q ∧ p :=
  have hp : p := h.left
  have hq : q := h.right
  show q ∧ p from And.intro hq hp
#print v1
-- theorem v1 : ∀ (p q : Prop), p ∧ q → q ∧ p :=
-- fun p q h =>
--   have hp := h.left;
--   have hq := h.right;
--   have this := ⟨hq, hp⟩;
--   this

-- 题 5 的 let / have 对照（自己跑一遍）：
theorem w1 (h : p ∧ q) : q ∧ p :=
  let hp : p := h.left
  let hq : q := h.right
  show q ∧ p from And.intro hq hp
theorem w2 (h : p ∧ q) : q ∧ p :=
  have hp : p := h.left
  have hq : q := h.right
  show q ∧ p from And.intro hq hp

-- 题 6 的「漏写后半句」实验（**这句会报错**，故意的）：
-- theorem x1 (h : p ∧ q) : q ∧ p :=
--   suffices hq : q
