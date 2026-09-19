/-
  第 2 章 · 第 3 课：`Prop` 与 `Type`（类型本身也是对象）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-3-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-3-示例.lean

  本课只讲一件事：**类型自己也有类型**；而「类型」分两个世界——
  `Type`（数据）与 `Prop`（命题）。
-/

/-! ## 1. 类型也有类型

    上一课问的是「值」的类型（`1 : Nat`）。这一课问的是「类型」的类型。
    读法：`Nat : Type` 意思是「`Nat` 这个东西的类型是 `Type`」。 -/

#check Nat                   -- Nat : Type
#check Bool                  -- Bool : Type
#check Nat → Bool            -- Nat → Bool : Type
#check Nat × Bool            -- Nat × Bool : Type
#check Nat → Nat             -- Nat → Nat : Type
#check Nat × Nat → Nat       -- Nat × Nat → Nat : Type
#check Nat → Nat → Nat       -- Nat → Nat → Nat : Type
#check (Nat → Nat) → Nat     -- (Nat → Nat) → Nat : Type

/-! ## 2. 给「类型」起名字：类型本身也是对象

    句型跟 `def m : Nat := 1` 完全一样——只不过这次「值」是一个**类型**。 -/

def α : Type := Nat
def β : Type := Bool

#check α                     -- α : Type
#check β                     -- β : Type
#check α × α                 -- α × α : Type

/-! ## 3. 给「吃类型、吐类型」的东西起名字

    `List` 是现成的：吃一个类型、吐一个类型。
    ⚠️ 你可能会在别处看到 `List.{u} (α : Type u) : Type u` 这种带 `.{u}` 的写法——
    那是**宇宙多态**，**本课不引入**（见讲义第 9 节）。 -/

def F : Type → Type := List
def G : Type → Type → Type := Prod

#check F                     -- F : Type → Type
#check F Nat                 -- F Nat : Type
#check G Nat Nat             -- G Nat Nat : Type

/-! ## 4. `Type` 自己的类型：一层层往上

    `Type` 装不下自己，所以 Lean 有一层层的宇宙。
    `Type` 其实就是 `Type 0` 的简写（下面第 2 行验证了这一点）。 -/

#check Type                  -- Type : Type 1
#check Type 0                -- Type : Type 1   ← 和上一行一样，说明 Type 就是 Type 0
#check Type 1                -- Type 1 : Type 2
#check Type 2                -- Type 2 : Type 3

/-! ## 5. 第二个宇宙：`Prop`（命题的世界）

    ⚠️ 第 1 行要注意：`Prop` **自己是一个类型**（所以它住在 `Type` 里），
    只是它装的东西不是数据，而是**命题**。 -/

#check Prop                  -- Prop : Type
#check True                  -- True : Prop
#check False                 -- False : Prop

/-! `True.intro` 是 `True` 的「值」——而命题的「值」叫**证明**。
    ⚠️ 怎么自己造证明，是第 3 章的内容，**本课不引入**。
    这里只需要认得这个位置关系：命题站在类型的位置，证明站在值的位置。 -/

#check True.intro            -- True.intro : True

/-! ## 6. `Sort`：`Prop` 与 `Type` 的统一叫法（番外，可选读）

    `Sort 0` 就是 `Prop`，`Sort 1` 就是 `Type`，`Sort 2` 就是 `Type 1`…… -/

#check Sort 0                -- Prop : Type
#check Sort 1                -- Type : Type 1
#check Sort 2                -- Type 1 : Type 2

/-! ## 7. 判据：一眼分清「类型 / 命题 / 值」

    判法：`#check X`，看**冒号右边**那一串——
      · 右边是 `Type`  → `X` 是**类型**
      · 右边是 `Prop`  → `X` 是**命题**
      · 右边是别的     → `X` 是**值** -/

#check Nat × Bool            -- Nat × Bool : Type   ← 类型
#check Prop                  -- Prop : Type         ← 类型（Prop 自己是类型）
#check True                  -- True : Prop         ← 命题
#check True.intro            -- True.intro : True   ← 值（一份证明）
