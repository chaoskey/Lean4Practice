/-
  第 2 章 · 第 9 课：依赖类型（dependent types）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-9-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-9-示例.lean
-/

/-! ## 1. 类型可以吃一个**值** -/

#check List          -- List.{u} (α : Type u) : Type u    ← 依赖【类型】
#check Fin           -- Fin (n : Nat) : Type              ← 依赖【值】！
#check Fin 3         -- Fin 3 : Type
#check Vector        -- Vector.{u} (α : Type u) (n : Nat) : Type u

#check (2 : Fin 3)   -- 2 : Fin 3
#eval (2 : Fin 3)    -- 2

/-! ## 2. 原文的 `cons`：给参数起名字，后面的类型才能「指回去」 -/

def cons (α : Type) (a : α) (as : List α) : List α :=
  List.cons a as

#check cons          -- cons (α : Type) (a : α) (as : List α) : List α
#check cons Nat      -- cons Nat : Nat → List Nat → List Nat    ← 返回类型跟着 α 变
#check cons Bool     -- cons Bool : Bool → List Bool → List Bool
#eval cons Nat 1 (cons Nat 2 List.nil)   -- [1, 2]

/-! ## 3. 依赖函数类型 `(a : α) → β a`

    不依赖的时候，它**就是**老的 `α → β`（实测两行输出一模一样）： -/

#check ((a : Nat) → Nat)   -- Nat → Nat : Type
#check (Nat → Nat)         -- Nat → Nat : Type

-- 真的依赖：返回类型里**有 n**
def depZero (n : Nat) : Fin (n + 1) :=
  0

#check depZero             -- depZero (n : Nat) : Fin (n + 1)
#check depZero 3           -- depZero 3 : Fin (3 + 1)    ← 注意不是 Fin 4
#eval depZero 3            -- 0
#check ((n : Nat) → Fin (n + 1))   -- (n : Nat) → Fin (n + 1) : Type

-- ⚠️ 上面右边那个 `0` 背后有一条**本课不解释**的规则：数字是「多态」的
--    （`0` 的类型由预期类型决定，机制叫**类型类实例**，属**第 10 章**）。
--    数学上的理由很简单：Fin (n+1) 的元素是 0..n，所以一定有 0。
--    而**一般的** `Fin n` 就不行：`def bad (n : Nat) : Fin n := 0` 会报
--    `failed to synthesize instance of type class OfNat (Fin n) 0`
--    （Lean 在报错里自己说：numerals are polymorphic in Lean）。

/-! ## 4. 依赖对（sigma）：第二个分量的类型依赖第一个分量 -/

def mkPair (α : Type) (β : α → Type) (a : α) (b : β a) : (a : α) × β a :=
  ⟨a, b⟩

#check mkPair
-- mkPair (α : Type) (β : α → Type) (a : α) (b : β a) : (a : α) × β a

-- `Σ` 写法 + `Sigma.mk`：和上面是**同一个东西**
def mkSigma (α : Type) (β : α → Type) (a : α) (b : β a) : Σ a : α, β a :=
  Sigma.mk a b

#check mkSigma
-- 打印出来是 × 那一版：
-- mkSigma (α : Type) (β : α → Type) (a : α) (b : β a) : (a : α) × β a

-- 取第二个分量：返回类型 β p.1 **依赖这个对本身**
def secondOf (α : Type) (β : α → Type) (p : (a : α) × β a) : β p.1 :=
  p.2

#check secondOf
-- secondOf (α : Type) (β : α → Type) (p : (a : α) × β a) : β p.fst
--                                                        ↑ p.1 与 p.fst 是同一个东西（02-2）

/-! ## 5. 💡 值可以**不**依赖参数（类型依赖 ≠ 值依赖）

    `depZero` 的类型依赖 n，但定义体里**没有用到 n**：
    而 `secondOf` 的返回值 `p.2` **确实用到了** p。 -/

#print depZero
-- def depZero : (n : Nat) → Fin (n + 1) :=
-- fun n => 0

#check (depZero 3)   -- depZero 3 : Fin (3 + 1)   ← 类型跟着 n 变
#check (depZero 7)   -- depZero 7 : Fin (7 + 1)
#eval (depZero 3)    -- 0                          ← 值不变
#eval (depZero 7)    -- 0

#print secondOf
-- def secondOf : (α : Type) → (β : α → Type) → (p : (a : α) × β a) → β p.fst :=
-- fun α β p => p.snd

/-! ## 6. 本课不引入的东西

    · `@` 记号与 `{}` 隐式参数（**下一课 2-10** = 原文 2.9）
    · 宇宙多态（`universe u v` / `Type u`）——还没有归属的课
    · `Fin` / `Vector` 的定义（`inductive`，第 7 章） -/
