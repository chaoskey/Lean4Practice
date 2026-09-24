/-
  第 3 章 · 第 3 课 · 习题：合取 `∧`

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-3-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：证明 `p ∧ (q ∧ r) → (p ∧ q) ∧ r`。

    约束：用**证明项**写（`fun` / `⟨,⟩` / `.left` / `.right` / `And.intro` …），不要用 tactic。

    提示：要交出的东西最外层是一个「对」；而它的**左边** `p ∧ q` 本身又是一个「对」
          —— 讲义 §8 说过 `⟨,⟩` 可以嵌着写。 -/
theorem ex1 (p q r : Prop) : p ∧ (q ∧ r) → (p ∧ q) ∧ r :=
  fun (hl : p ∧ (q ∧ r))  => ⟨ ⟨hl.left , hl.right.left ⟩, hl.right.right ⟩

/- 题 2：证明 `(p → q) → p ∧ r → q ∧ r`。

    提示：先想清楚**要交出什么形状的项**，再想「`q` 的证明从哪来」「`r` 的证明从哪来」。 -/
theorem ex2 (p q r : Prop) : (p → q) → p ∧ r → q ∧ r :=
  fun (h1 : p → q) => fun (h2 : p ∧ r ) => ⟨ h1 h2.left , h2.right ⟩

/- 题 3：证明 `p → q → q ∧ p`。

    ⚠️ 提示：注意**引入假设的顺序**与**结果里两个分量的顺序**——03-2 题 3 你在这上面栽过一次。 -/
theorem ex3 (p q : Prop) : p → q → q ∧ p :=
  fun (hp : p) => fun (hq : q) => ⟨ hq , hp ⟩


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`#check And.intro` 会打印出**什么**？把整行抄下来。

    提示：注意它的**隐式参数**（花括号那部分）和**两个参数的名字**（讲义 §3 有类型，
          但请你自己先猜，再取消注释核对）。

    我的答案：And.intro {a b : Prop} (left : a) (right : b) : a ∧ b -/


/- 题 5：设 `h : p ∧ q`。下面四个表达式的**类型**各是什么？（四个都写）

    · `h.left`
    · `h.right`
    · `h.1`
    · `h.2`

    我的答案：p , q , p , q -/


/- 题 6：`⟨hp, hq⟩`（其中 `hp : p`、`hq : q`）与 `And.intro hp hq`：

    ① 它们是**同一个东西**吗？
    ② 用 `#check` 去问，Lean 会把它们**打印成什么形状**？

    提示：`#check` 打的是 **Lean 的输出**，不是你写进去的东西——03-1 题 4 学过这条。

    我的答案： 是同一个东西。 打印的应该都是  ⟨hp, hq⟩ : p ∧ q -/


/- 题 7：下面两个 `#check` 能**通过**吗？为什么？

    ① `#check And Nat Nat`
    ② 在 `variable (p q : Prop)` 之下：`#check Prod p q`

    提示：想一想 `And` 与 `Prod` 各自「吃」的是**哪个世界**里的东西（03-1 学过 `Prop` 与 `Type`）。

    我的答案：第一个不能通过，因为它只能作用于命题 Prop。 这个应该也不能通过,因为它只能作用于类型世界， 虽然 Prop 也是一种类型， 但是 Prod 这个笛卡尔积作用于某种数据，而不是 Prop。 -/


/- 题 8：`example` 命令与 `theorem` 命令有什么区别？

    提示：讲义 §7。至少说清两件事：**名字**、以及**之后能不能再引用它**。

    我的答案：example 可以理解成匿名的 theorem。前者没有名字，后者有名字。而且 theorem 声明的定理可以在之后引用，example 声明的例子通常不被引用。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#check And.intro -- And.intro {a b : Prop} (left : a) (right : b) : a ∧ b
#print And  --  这个打印出来应该比较复杂，你的讲义中说只要认识就可以，不需要掌握。
#check And.left  -- And.left {a b : Prop} (self : a ∧ b) : a
#check And.right -- And.right {a b : Prop} (self : a ∧ b) : b

variable (p q : Prop)
variable (hp : p) (hq : q)
#check (⟨hp, hq⟩ : p ∧ q) -- ⟨hp, hq⟩ : p ∧ q
#check (And.intro hp hq) -- ⟨hp, hq⟩ : p ∧ q
#check (fun (h : p ∧ q) => h.left)  -- fun h => h.left : p ∧ q → p
#check (fun (h : p ∧ q) => h.right) -- fun h => h.right : p ∧ q → q
#check (fun (h : p ∧ q) => h.1)  -- fun h => h.left : p ∧ q → p
#check (fun (h : p ∧ q) => h.2)  -- fun h => h.right : p ∧ q → q

-- 题 7 的两个（自己跑一遍，看结果是否如你所料）：
-- #check (And Nat Nat)  -- 肯定不通过
-- #check (Prod p q)  -- 肯定不通过

-- 题 8 的对照：
theorem demo : p → p := fun hp => hp
#check demo  -- demo (p : Prop) : p → p
