/-
  第 3 章 · 第 6 课 · 习题：逻辑等价 `↔`

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-6-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：证明 `(p ∨ p) ↔ p`。

    约束：用**证明项**写，不要用 tactic。

    提示：先问自己「**要交几样东西**」——一个 `↔` 要**两个方向**。
          正向：手上是「`p` 或 `p`」，怎么**收成一个** `p`？（3-4 的分情况）
          反向：手上是 `p`，怎么变成「`p` 或 `p`」？（3-4 的两选一）

    我的答案： -/
theorem ex1 (p : Prop) : (p ∨ p) ↔ p :=
  ⟨
    fun h : p ∨ p => h.elim (fun hp : p => hp) (fun hp : p => hp),
    fun hp : p => Or.inl hp
  ⟩

/- 题 2：证明 `(p ∨ q) ↔ (q ∨ p)`（析取的交换律）。

    提示：又是**两个方向**。两个方向**各自**都要面对「手上是 `p ∨ q`、要交出 `q ∨ p`」这种形状——
          所以先写好**其中一个**方向，确认它能过，再照着改另一个（**注意两边要交换的位置不同**）。
          ⚠️ 写 `Or.inl` / `Or.inr` 之前，先问一句「**它要的是不是我要喂的那一边**」。

    我的答案： -/
theorem ex2 (p q : Prop) : (p ∨ q) ↔ (q ∨ p) :=
  ⟨
    fun h : p ∨ q => h.elim (fun hp : p => Or.inr hp) (fun hq : q => Or.inl hq),
    fun h : q ∨ p => h.elim (fun hq : q => Or.inr hq) (fun hp : p => Or.inl hp)
  ⟩

/- 题 3：已知 `h : p ↔ q`，证明 `q ↔ p`。

    提示：这题**只有一个**方向要证，但**要交两个**方向。
          第一个方向（从 `q` 到 `p`）和第二个方向（从 `p` 到 `q`）**各自**要什么？
          手上那个 `h` 能不能直接用？用它的哪一个？

    我的答案： -/
theorem ex3 (p q : Prop) (h : p ↔ q) : q ↔ p :=
  ⟨
    fun hq : q => h.mpr hq,
    fun hp : p => h.mp hp
  ⟩


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`#print Iff` 的输出里，`fields:` 下面有**几个**字段？把那两个字段的**名字**抄下来。
          `constructor:` 下面有**几个**构造子？（对照 3-3 的 `#print And`）

    我的答案：`fields:` 下面有两个字段： Iff.mp : a → b  和 Iff.mpr : b → a ； `constructor:` 下面有一个构造子 ： Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b -/


/- 题 5：`#check Iff.intro` 会打印出**什么**？把整行抄下来，并回答两问：
          ① 它有**几个显式**参数？各自是什么类型？
          ② 顺序是「先正向、后反向」还是「先反向、后正向」？

    我的答案：Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b
    有两个显式参数，分别是: mp : a → b 和 mpr : b → a
    先正向后反向  -/


/- 题 6：`p ↔ q` 与 `(p → q) ∧ (q → p)` 是**同一个类型**吗？请给出一条**依据**
          （讲义 §4 有实测代码）。⚠️ 这个问题**不要**和 3-5 题 7 的答案写成一样——
          3-5 那一问的答案是「是」，**这一问的答案正好相反**。

    我的答案：不是同一个类型，因为
    -- ❌ 下面这句**不通过**：
    --
    -- example (h : p ↔ q) : (p → q) ∧ (q → p) := h
    --   ↑ error: Type mismatch
    --     h has type p ↔ q but is expected to have type (p → q) ∧ (q → p)
     -/


/- 题 7：设 `h : p ↔ q`。下面四个记号，**哪些能用**、**哪些不能**？逐个判断并说明理由：
          `h.mp`、`h.mpr`、`h.left`、`h.1`

    我的答案：1 2 4 能用，而 3 不能用。
    h.mp、h.mpr 能用——因为 #print Iff 的 fields: 里就有这两个字段（名字对得上，Lean 才知道给你点记号）；
    h.left 不能用——因为 Iff 没有叫 left 的字段（left 是 And 的，#print Iff 里查不到）；
    h.1 能用——因为数字记号取第 1 个字段，而第 1 个字段就是 mp（.1 与 .mp 指同一个东西）。
     -/


/- 题 8：含 `↔` 的表达式里，括号有多重要？回答两问：
          ① `#check (p ↔ q ↔ r)` 能不能通过？
          ② 要表达「`p` 蕴含『`q` 当且仅当 `r`』」，应该写哪一种？
             （甲）`p → q ↔ r`　（乙）`p → (q ↔ r)`　（丙）`(p → q) ↔ r`

    我的答案：① 实测不通过；   ② 应该写乙，即 `p → (q ↔ r)`。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- ⚠️ 讲义 §4、§5、§8 里那些**故意写错**的写法在**讲义里**（不参与本文件的检查）。

#check Iff -- Iff (a b : Prop) : Prop
#print Iff
-- structure Iff (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   Iff.mp : a → b
--   Iff.mpr : b → a
-- constructor:
--   Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b
#print And
-- structure And (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   And.left : a
--   And.right : b
-- constructor:
--   And.intro {a b : Prop} (left : a) (right : b) : a ∧ b
#check Iff.intro -- Iff.intro {a b : Prop} (mp : a → b) (mpr : b → a) : a ↔ b
#check Iff.mp  -- Iff.mp {a b : Prop} (self : a ↔ b) : a → b
#check Iff.mpr  -- Iff.mpr {a b : Prop} (self : a ↔ b) : b → a

-- 题 8 的括号实验（自己跑一遍）：
variable (p q r : Prop)
-- #check (p ↔ q ↔ r)  不通过
#check (p ↔ (q ↔ r))  -- p ↔ (q ↔ r) : Prop
#check ((p ↔ q) ↔ r)  -- (p ↔ q) ↔ r : Prop
#check (p → (q ↔ r)) -- p → (q ↔ r) : Prop
#check (p → q ↔ r)  -- p → q ↔ r : Prop
