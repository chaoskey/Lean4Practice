/-
  第 3 章 · 第 5 课 · 习题：否定 `¬`

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-5-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：证明 `¬(p ∧ ¬p)`。

    约束：用**证明项**写，不要用 tactic。

    提示：目标是 `¬(p ∧ ¬p)`，所以先 `fun h => …` 把手上的那个「对」接过来；
          问自己「**这个对里有哪两样东西**」。

    我的答案： -/
theorem ex1 (p : Prop) : ¬(p ∧ ¬p) :=
  fun h : p ∧ ¬p =>
    absurd h.left (fun hp : p => h.right hp)

/- 题 2：证明 `¬p → ¬q → ¬(p ∨ q)`。

    提示：注意**目标怎么展开**：三个 `¬` 各是什么形状？最外面那个是「要从什么推出什么」？
          里面的 `p ∨ q` 提醒你 3-4 学过的**分情况**。

    我的答案： -/
theorem ex2 (p q : Prop) : ¬p → ¬q → ¬(p ∨ q) :=
  fun hnp : ¬p => fun hnq : ¬q =>
    fun h : p ∨ q =>
        h.elim (fun hp : p => hnp hp) (fun hq : q => hnq hq)
--      Or.elim h (fun hp : p => hnp hp) (fun hq : q => hnq hq)

/- 题 3：证明 `q → ¬(p → q) → False`。

    ⚠️ 这题有两个坑：
       ① 目标**最后是 `False`**（不是某个 `¬…`）——讲义 §6 讲过为什么这样写更稳；
       ② 最内层要造一个 `p → q`，**它的参数用不上**——给它加下划线前缀，
          否则 Lean 会报 unused variable 的 warning（03-2 §4 学过）。

    我的答案： -/
theorem ex3 (p q : Prop) : q → ¬(p → q) → False :=
  fun hq : q => fun h : ¬(p → q) => h (fun _hp : p => hq)


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`#check Not` 与 `#check False` 各会打印出**什么**？两行都抄下来。

    我的答案：
    Not (a : Prop) : Prop
    False : Prop
     -/


/- 题 5：`#print False` 的输出里，`constructors:` 后面有东西吗？
          把它和 3-3 的 `#print And` 对比，说出**「假」在 Lean 里的含义**。

    我的答案：前者没有构造子，说明 `False` 是不可构造的，也就是 Lean 里的「假」；而后者有一个构造子 `And.intro`，说明 `And` 是可构造的。 -/


/- 题 6：`#check False.elim` 会打印出**什么**？把整行抄下来，并回答两问：
          ① 那个 `C` 是**隐式**参数还是**显式**参数？要不要你手写？
          ② `absurd` 的两个**显式**参数，顺序是「先证明」还是「先否定」？

    我的答案：
    False.elim.{u} {C : Sort u} (h : False) : C
    用花括号构造的都是隐式参数， 所以 C 是一个隐式参数，不需要手写。
    `absurd` 的两个**显式**参数 ， 是先证明，第二个参数才是否定。
     -/


/- 题 7：设 `h : ¬p`。`h` 与「一个类型是 `p → False` 的东西」是**同一个东西**吗？
          请给出一条**依据**（讲义 §3 里有两条实测的代码）。

    我的答案：是同一个东西。因为两个方向的 example 都能编译
    example (h : ¬p) : p → False := h        -- 一个方向能编译
    example (h : p → False) : ¬p := h        -- 另一个方向也能编译
    ——一个方向证明不了「同一个」，两个方向都在才说明它们的类型按定义相等。
     -/


/- 题 8：下面两个 `theorem` 声明，**哪个能通过**？（两个都错就写「都错」）

          ① `theorem v : q → ¬(p → q) → False := fun hq h => h (fun hp : p => hq)`
          ② `theorem v : q → ¬(p → q) := fun hq h => h (fun hp : p => hq)`

    提示：讲义 §6 用这两条的**实测报错原文**讲过原因；先自己判断，再去对照。

    我的答案：第一种情况我们前面做过习题，肯定是对的。第二个，那是肯定是不对的。② 报 Application type mismatch（讲义 §6 实测）。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- ⚠️ 题 8 那两条**故意写错**的声明在**讲义 §6**（不参与本文件的检查）。

#check Not  -- Not (a : Prop) : Prop
#check False -- False : Prop
#print False
-- inductive False : Prop
-- number of parameters: 0
-- constructors:
#print And
-- structure And (a b : Prop) : Prop
-- number of parameters: 2
-- fields:
--   And.left : a
--   And.right : b
-- constructor:
--   And.intro {a b : Prop} (left : a) (right : b) : a ∧ b
#print Or
-- inductive Or : Prop → Prop → Prop
-- number of parameters: 2
-- constructors:
-- Or.inl : ∀ {a b : Prop}, a → a ∨ b
-- Or.inr : ∀ {a b : Prop}, b → a ∨ b
#check False.elim -- False.elim.{u} {C : Sort u} (h : False) : C
#check absurd -- absurd.{v} {a : Prop} {b : Sort v} (h₁ : a) (h₂ : ¬a) : b
#check True.intro  -- True.intro : True
#print False.elim -- def False.elim.{u} : {C : Sort u} → False → C := fun {C} h => False.rec (fun x => C) h
#print absurd  -- def absurd.{v} : {a : Prop} → {b : Sort v} → a → ¬a → b := fun {a} {b} h₁ h₂ => False.rec (fun x => b) ⋯

-- 题 7 的两条（自己跑一遍，对照讲义 §3）：
variable (p : Prop)
example (h : ¬p) : p → False := h
example (h : p → False) : ¬p := h
