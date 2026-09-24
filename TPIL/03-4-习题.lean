/-
  第 3 章 · 第 4 课 · 习题：析取 `∨`

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-4-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：证明 `p → p ∨ q`。

    约束：用**证明项**写（`fun` / `Or.inl` / `Or.inr` / `Or.intro_left` / `Or.intro_right` …），不要用 tactic。

    提示：先看**目标**（冒号后面那个类型）长什么样——`∨` 的目标有两个构造子，
          而你手里只有一个证明：问自己「这个证明够喂给哪一个」。
          ⚠️ 特别提醒：`inl` 与 `inr` 各自吃的是**哪一边**，别拿反了。 -/
theorem ex1 (p q : Prop) : p → p ∨ q :=
  fun (hp : p) => Or.inl hp

/- 题 2：证明 `p → q → p ∨ q`。

    提示：与题 1 相比，你**多了一个**假设——想清楚**哪个假设用得上**、
          **另一个用不上**（用不上的名字记得加下划线前缀，否则 Lean 会报
          unused variable 的 warning）。 -/
theorem ex2 (p q : Prop) : p → q → p ∨ q :=
  fun (hp : p) => fun (_ :q) => Or.inl hp

/- 题 3：证明 `p ∨ q → (p → r) → (q → r) → r`。

    提示：把讲义 §6 那张「`Or.elim` 三个参数」的类型表调出来，对照你手上的东西，
          按**位置**一个个对进去。 -/
theorem ex3 (p q r : Prop) : p ∨ q → (p → r) → (q → r) → r :=
  fun (hpq : p ∨ q) => fun (hpr : p → r) => fun(hqr : q → r) => Or.elim hpq hpr hqr


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`#check Or.inl` 会打印出**什么**？把整行抄下来。

    提示：注意它的**隐式参数**（花括号那部分）和**参数的名字**。
          但请你自己先猜，再取消注释核对。

    我的答案：Or.inl {a b : Prop} (h : a) : a ∨ b -/


/- 题 5：`#check Or.elim` 会打印出**什么**？把整行抄下来，
          并用中文说明它那**三个参数**各自是干什么的。

    提示：讲义 §6 有这张表的解读；隐式参数不算在那三个「吃进去的东西」里。

    我的答案：Or.elim {a b c : Prop} (h : a ∨ b) (left : a → c) (right : b → c) : c
          第一参数，给出的命题是 a 或者 b； 第二个参数代表 a 蕴含着 c ; 第三个参数代表 b 蕴含着 c。-/


/- 题 6：3-3 里 `⟨hp, hq⟩` 能造出 `p ∧ q`。为什么它**不能**造 `p ∨ q`？

    提示：把 `#print And` 与 `#print Or` 的输出对读——找出**决定性的那一点不同**。

    我的答案： And 只有 1 个（And.intro）→ ⟨,⟩ 知道该用哪个；Or 有 2 个（Or.inl / Or.inr）→ ⟨,⟩ 无从选择。 -/


/- 题 7：`h.elim` 是什么的简写？它与 3-3 讲过的 `h.left` 是**同一种**点记号吗？

    提示：点记号的通用规则是「表达式.方法名」= 「方法名 表达式」；套上去看两边各是什么。

    我的答案：`h.elim` 是 `Or.elim h` 的简写， 和 `h.left` 是**同一种**点记号 。 -/

/- 题 8：`Or.inl` 与 `Or.intro_left` 是什么关系？
          `Or.inl` 为什么能**少写**一个参数？

    提示：把两者的类型并排抄下来，对比**哪个参数不见了**；
          再想：那个参数是谁替我们填上的？

    我的答案：
    Or.inl {a b : Prop} (h : a) : a ∨ b
    Or.intro_left {a : Prop} (b : Prop) (h : a) : a ∨ b

    很明显，Or.inl 的参数更少， 因为它的第二个命题参数 b 可以由 Lean 自动推断出来，而 Or.intro_left 需要显式提供。
     -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- ⚠️ 题 6 的报错原文在**讲义 §5**（那里把**故意写错**的代码放在普通代码块里，
--    所以本文件里没有它；要看实测报错，去对照讲义 §5 那一段）。

#check Or.inl  -- Or.inl {a b : Prop} (h : a) : a ∨ b
#check Or.inr -- Or.inr {a b : Prop} (h : b) : a ∨ b
#check Or.intro_left  -- Or.intro_left {a : Prop} (b : Prop) (h : a) : a ∨ b
#check Or.intro_right -- Or.intro_right {b : Prop} (a : Prop) (h : b) : a ∨ b
#check Or.elim  -- Or.elim {a b c : Prop} (h : a ∨ b) (left : a → c) (right : b → c) : c
#print Or   -- 不需要逐行分析，讲义 §4 已给出输出
#print And  -- 不需要逐行分析，讲义 §4 已给出输出
