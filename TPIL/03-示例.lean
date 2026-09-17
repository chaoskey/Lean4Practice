/-
  TPIL 第 3 章 · 第 1 部分：蕴含 `→`
  示范示例（全部已通过 Lean 编译）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `03-习题.lean`。
  这里每个证明都可以直接抄进 REPL 试，它们保证是对的。

  检查本文件：
    export PATH="$HOME/.elan/bin:$PATH"
    lake env lean TPIL/03-示例.lean
-/

/-! ## 1. 先分清两个世界：`Prop`（命题）与 `Type`（数据）

    `#check` 的输出格式一律是：   表达式 : 它的类型
    判据：看一个类型的「值」是**证明**还是**数据**。 -/

#check Nat            -- Nat : Type       ← 数据类型【不是命题！】
#check 1 + 1          -- 1 + 1 : Nat      ← 数据：Nat 的一个值
#check 2 = 2          -- 2 = 2 : Prop     ← 命题
#check (rfl : 2 = 2)  -- rfl : 2 = 2      ← 证明：命题的一个值

-- 上面后两行才是本课的主题：`2 = 2` 是类型（命题），`rfl` 是它的值（证明）。
-- 前两行只是对照：`Nat` 也是「类型」，但在另一个世界（`Type`），它的值是数字。

-- `#check` 只报类型、不做计算，所以 1 + 1 不会被化成 2。
-- 要看计算结果用 `#eval`：
#eval 1 + 1           -- 2

-- 想知道某个定理的类型，也可以 #check：
#check Nat.add_comm


/-! ## 2. 证明 `p → p`：蕴含就是函数 -/

-- 项模式：给我一个 p 的证明，原样还给你
example (p : Prop) : p → p := fun hp => hp

-- 策略模式：与上面完全等价
example (p : Prop) : p → p := by
  intro hp
  exact hp


/-! ## 3. 箭头右结合，需要连续 intro -/

-- p → q → p  其实是  p → (q → p)
example (p q : Prop) : p → q → p := by
  intro hp hq
  exact hp

-- 用不到的假设可以写成 _
example (p q : Prop) : p → q → p := fun hp _ => hp


/-! ## 4. 使用蕴含：函数应用 -/

-- 手里有 h : p → q 和 hp : p，调用函数得到 q
example (p q : Prop) (hp : p) (h : p → q) : q := h hp

example (p q : Prop) (hp : p) (h : p → q) : q := by
  exact h hp


/-! ## 5. `apply`：从目标往回退 -/

-- 逐步看目标变化：
--   开始        ⊢ p → r
--   intro hp    ⊢ r          （新增 hp : p）
--   apply h2    ⊢ q          （h2 : q → r）
--   apply h1    ⊢ p          （h1 : p → q）
--   exact hp    完成
example (p q r : Prop) (h1 : p → q) (h2 : q → r) : p → r := by
  intro hp
  apply h2
  apply h1
  exact hp

-- 同样一件事，写成项模式就是函数复合
example (p q r : Prop) (h1 : p → q) (h2 : q → r) : p → r := fun hp => h2 (h1 hp)


/-! ## 6. 一个稍大的例子：同一前提用两次 -/

-- (p → p → q) → p → q
example (p q : Prop) (h : p → p → q) : p → q := by
  intro hp
  apply h
  · exact hp
  · exact hp

-- 项模式：
example (p q : Prop) (h : p → p → q) : p → q := fun hp => h hp hp


/-! ## 7. 故意写错的例子（放在注释里，因为它编译不过）

如果你写：

    example (p q : Prop) (hp : p) : q := hp

Lean 会报：

    error: Type mismatch
      hp
    has type
      p
    but is expected to have type
      q

**重点看后两段**：`has type p` / `is expected to have type q`。
「你给的 hp 类型是 p，但这里需要 q」——初学阶段的报错基本都是这个形状。
-/
