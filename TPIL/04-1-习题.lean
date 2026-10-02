/-
  第 4 章 · 第 1 课 · 习题：全称量词 `∀`

  规则：
    · 全部 6 道：**写证明**（把 `sorry` 换掉）
    · 用**证明项**写，不要用 tactic（tactic 是第 5 章的内容，本课不引入）

  检查：
    lake env lean TPIL/04-1-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
  ⚠️ 本文件里**一处 `sorry` 都不能留**。

  📌 本课的通用提示：**看到目标里出现 `∀ x, …`，第一个动作就是写 `fun x =>`。**
     本课全部 6 题**都不需要经典逻辑**（零公理可证）。
-/

variable (α : Type) (p q : α → Prop)

/- ============================================================
   题 1–6
   ============================================================ -/

/- 题 1：把一个 `∀` 放宽成析取。

    提示：目标是 `∀ x, p x ∨ q x`——先收下一个任意的 `x`。
          要交出 `p x ∨ q x`，注意**哪一边是你手上有的**。

    我的答案： -/
theorem ex1 : (∀ x, p x) → ∀ x, p x ∨ q x :=
  -- fun h : (∀ x, p x) => show ∀ x, p x ∨ q x from (
  --   fun x => show p x ∨ q x from (
  --     Or.inl (h x)
  --   )
  -- )
  fun h => fun x => Or.inl (h x)

/- 题 2：把一个「逐点的合取」拆成「两个全称」。

    提示：目标是一个 `∧`——**同时**交两样东西，而每一样本身又是一个 `∀`。

    我的答案： -/
theorem ex2 : (∀ x, p x ∧ q x) → (∀ x, p x) ∧ (∀ x, q x) :=
  -- fun h : (∀ x, p x ∧ q x) => show (∀ x, p x) ∧ (∀ x, q x) from (
  --   ⟨
  --     -- ∀ x, p x
  --     fun x => show p x from (h x).left
  --     ,
  --     -- ∀ x, q x
  --     fun x => show q x from (h x).right
  --   ⟩
  -- )
  fun h => ⟨ fun x => (h x).left, fun x => (h x).right ⟩

/- 题 3：把两个 `∀` 串起来（这条是「蕴含的传递」，只是加了变量）。

    提示：目标 `∀ x, q x`——先 `fun x`。
          然后你手上有 `∀ x, p x → q x` 和 `∀ x, p x`，都要**先喂 `x`**。

    我的答案： -/
theorem ex3 : (∀ x, p x → q x) → (∀ x, p x) → ∀ x, q x :=
  -- fun (h1 : ∀ x, p x → q x) (h2 : ∀ x, p x) => show ∀ x, q x from (
  --   fun x => show q x from (
  --     (h1 x) (h2 x)
  --   )
  -- )
  fun h1 h2 => fun x => h1 x (h2 x)

/- 题 4：把绑定变量**换个名字**。

    提示：本课 §7 讲过 `∀ x, p x` 与 `∀ y, p y` 是**同一个命题**。
          ⚠️ 注意收下来的变量名和用的时候的名字要对上。

    我的答案： -/
theorem ex4 : (∀ x, p x) → ∀ y, p y :=
  -- fun h : (∀ x, p x) => show ∀ y, p y from (
  --   fun y => show p y from h y
  -- )
  fun h => fun y => h y    -- fun h y => h y

/- 题 5：逐点地把合取**换边**。

    提示：和题 2 的「拆」不同——这条全程留在 `∀` 里面。

    我的答案： -/
theorem ex5 : (∀ x, p x ∧ q x) → ∀ x, q x ∧ p x :=
  -- fun h : (∀ x, p x ∧ q x) => show ∀ x, q x ∧ p x from (
  --   fun x => show q x ∧ p x from (
  --     ⟨
  --       -- q x
  --       (h x).right
  --       ,
  --       -- p x
  --       (h x).left
  --     ⟩
  --   )
  -- )
  fun h => fun x => ⟨ (h x).right, (h x).left ⟩  -- fun h x => ⟨ (h x).right, (h x).left ⟩

/- 题 6：⚠️ 这条有**两层**量词，而且两层的变量**不同名**。

    提示：数一数 `(∀ x y, p x → q y)` 里有几个 `∀`。
          目标是 `∀ y, q y`——先收下 `y`；但要用上那个两层的假设，
          还得**再给它一个 `x`**，而那个 `x` 从哪来，看你的第二个假设。

    我的答案： -/
theorem ex6 : (∀ x y, p x → q y) → (∀ x, p x) → ∀ y, q y :=
  -- fun (h1 : ∀ x y, p x → q y) (h2 : ∀ x, p x) => show ∀ y, q y from (
  --   fun y => show q y from (
  --     (h1 y y) (h2 y)
  --   )
  -- )
  fun h1 h2 => fun y => h1 y y (h2 y)  -- fun h1 h2 y => h1 y y (h2 y)


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

--
-- 对照实验（想验证「∀ 和 → 是同一个类型」时用）：
-- 写两个同义的类型，各绑定给一个 `example`，看 Lean 接受不接受。
example (α : Type) (p : α → Prop) (h : ∀ x : α, p x) : (x : α) → p x := h
example (α : Type) (p : α → Prop) (h : (x : α) → p x) : ∀ y : α, p y := h
