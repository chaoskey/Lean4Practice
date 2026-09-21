/-
  第 2 章 · 第 10 课：隐式参数（implicit arguments）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-10-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-10-示例.lean
-/

/-! ## 1. 问题：类型参数写起来太啰嗦 -/

def Lst (α : Type) : Type := List α
def Lst.cons (α : Type) (a : α) (as : Lst α) : Lst α := List.cons a as
def Lst.nil (α : Type) : Lst α := List.nil

-- `Nat` 被写了 4 遍，而它一个都不用写
#check Lst.cons Nat 0 (Lst.nil Nat)
def as : Lst Nat := Lst.nil Nat
def bs : Lst Nat := Lst.cons Nat 5 (Lst.nil Nat)

/-! ## 2. 下划线 `_`：让 Lean 自己填（输出与写全 Nat 一模一样） -/

#check Lst.cons _ 0 (Lst.nil _)
def as2 : Lst Nat := Lst.nil _
def bs2 : Lst Nat := Lst.cons _ 5 (Lst.nil _)

/-! ## 3. 花括号 `{}`：默认就不用写 -/

def Lst2.cons {α : Type} (a : α) (as : List α) : List α := List.cons a as
def Lst2.nil {α : Type} : List α := List.nil

#check Lst2.cons 0 Lst2.nil          -- Nat 一次都没出现，类型还是 List Nat
def as3 : List Nat := Lst2.nil
def bs3 : List Nat := Lst2.cons 5 Lst2.nil

-- 花括号也能用在普通函数定义里
def myId {α : Type} (x : α) : α := x

#check (myId)          -- myId : ?m.1 → ?m.1    ← ?m.1 是「待定」（没给任何线索）
#check myId 1          -- myId 1 : Nat
#check myId true       -- myId true : Bool
#check @myId           -- @myId : {α : Type} → α → α

/-! ## 4. `variable` 也能声明隐式 -/

section
  variable {α : Type}
  variable (x : α)
  def myId2 := x
end

#check myId2           -- myId2 {α : Type} (x : α) : α   ← 打印里带花括号 = 隐式
#check myId2 4         -- myId2 4 : Nat
#check myId2 true      -- myId2 true : Bool

/-! ## 5. `(e : T)`：给它一个类型，帮 Lean 把隐式参数定下来 -/

#check (List.nil)              -- [] : List ?m.1     ← 信息不够 → 待定
#check (List.nil : List Nat)   -- [] : List Nat      ← 给类型就定下来了
#check (myId)                  -- myId : ?m.1 → ?m.1
#check (myId : Nat → Nat)      -- myId : Nat → Nat

/-! ## 6. `@foo`：把所有参数都变回显式 -/

#check @myId           -- @myId : {α : Type} → α → α   ← 花括号**还在**！
#check @myId Nat       -- myId : Nat → Nat
#check @myId Nat 1     -- myId 1 : Nat
#check (@myId Bool true)   -- myId true : Bool

/-! ## 7. 数字是多态的（推不出来时默认 Nat） -/

#check 2               -- 2 : Nat     ← 没给线索 → 默认
#check (2 : Nat)       -- 2 : Nat
#check (2 : Int)       -- 2 : Int     ← 明说了就听你的

/-! ## 8. 本课不引入的东西

    · `universe u` / `Type u` / `Sort`（宇宙多态，还没有归属的课）
    · 类型类（数字重载的实现机制，第 10 章）
    · `{}` 的更多变体（`⦃…⦄`、`{{…}}`） -/
