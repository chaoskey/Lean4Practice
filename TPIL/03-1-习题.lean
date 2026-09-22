/-
  第 3 章 · 第 1 课 · 习题：命题即类型（Propositions as Types）

  规则：
    · 前三题：在**类型层级**上把三个逻辑命题写成 `Prop`（把 `sorry` 换掉）
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-1-习题.lean

  ⚠️ 本课**没有 `#eval`**（`Prop` 是不能求值的），所以验证区随时可以取消注释核对。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、在类型层级上写三个命题 ============ -/

/- 题 1：写一个定义 `threeImp`，让 `threeImp p q r` 表示这个命题：
    「**`p` 蕴含（`q` 蕴含 `r`）**」。
    （提示：讲义 §3 说过「蕴含在类型层级上是什么」——这里只需要箭头。） -/
def threeImp (p q r : Prop) : Prop :=
  p → (q → r)

/- 题 2：写一个定义 `andOr`，让 `andOr p q r` 表示**和 `p ∧ q ∨ r` 同一个命题**——
    但**约束**：`∧` 和 `∨` 这两个**记号一个都不许用**，只能写它们的**函数形式**。
    （提示：讲义 §8 说的「记号只是函数形式的糖」。） -/
def andOr (p q r : Prop) : Prop :=
  Or (And p q ) r

/- 题 3：写一个定义 `compose`，让 `compose p q r` 表示这个命题：
    「**如果（`p` 蕴含 `q`）并且（`q` 蕴含 `r`），那么（`p` 蕴含 `r`）**」。
    （提示：两个命题之间的「并且」也有函数形式——见讲义 §8 的 `#check` 清单。） -/
def compose (p q r : Prop) : Prop :=
  (And (p → q) (q → r) ) → (p → r)


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：已知 `variable (p q : Prop)`，`#check And p q` 会打印出什么？
    为什么你写的是 `And p q`，打印出来的却是别的东西？

    我的答案：p ∧ q : Prop .因为 Lean 有记号时就用记号打印 -/


/- 题 5：`#check Not`、`#check True`、`#check False` 分别打印什么？
    换句话说：`True` 和 `False` 这两个东西的**类型**是什么？

    我的答案：Not (a : Prop) : Prop , True : Prop , False : Prop  . `True` 和 `False` 这两个东西的**类型**是什么 Prop-/


/- 题 6：如果 `p q : Prop`，那么 `p → q` 的**类型**是什么？
    这件事为什么重要？（提示：`→` 这个记号在第 2 章是什么身份？）

    我的答案：p → q : Prop 。这是重要的，因为它说明在 Lean 中，命题之间的箭头仍然是命题，也就是 `→` 在类型层级上对应的是函数类型。 -/


/- 题 7：「**proof irrelevance（证明无关）**」说的是什么？
    它意味着「一个证明」**携带多少信息**？

    我的答案：证明无关意味着同一个命题的不同证明 按定义是相等 ，证明不携带「命题为真」以外的任何信息，具体来说，证明的具体内容不影响命题的真值。 -/


/- 题 8：用**一句话**说清「**命题即类型**（propositions as types）」是什么意思；
    并且说明 `t : p` 这一行该怎么**读**。

    我的答案：命题即类型意味着每一个命题 `p` 都对应一个类型，而 `t : p` 表示 `t` 是命题 `p` 的一个证明。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#check threeImp -- threeImp (p q r : Prop) : Prop
#check andOr  -- andOr (p q r : Prop) : Prop
#check compose  -- compose (p q r : Prop) : Prop

-- 额外核对（讲义 §8 的那份清单）：
variable (p q r : Prop)
#check And  -- And (a b : Prop) : Prop
#check Or  -- Or (a b : Prop) : Prop
#check Not  -- Not (a : Prop) : Prop
#check True  -- True : Prop
#check False  -- False : Prop
#check And p q -- p ∧ q : Prop
#check Or (And p q) r -- p ∧ q ∨ r : Prop
#check (p → q) -- p → q : Prop
#check (fun (hp : p) => hp) -- fun hp => hp : p → p
