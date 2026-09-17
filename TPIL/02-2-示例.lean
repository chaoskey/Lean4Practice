/-
  第 2 章 · 第 2 课：从已有类型造新类型（`→` 和 `×`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-2-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-2-示例.lean
-/

/-! ## 1. 函数类型：`a → b`

    「从 a 到 b 的函数」本身也是一个**类型**。 -/

#check Nat → Nat        -- Nat → Nat : Type
#check Bool → Nat       -- Bool → Nat : Type

/- 输入 `\to` 或 `\r` 可以得到 `→`；ASCII 写法 `->` 完全等价。 -/


/-! ## 2. 对（笛卡尔积）：`a × b`

    「一个 a 和 一个 b 组成的二元组」也是一个类型。 -/

#check Nat × Nat        -- Nat × Nat : Type
#check Nat × Bool       -- Nat × Bool : Type

/- `×` 输入 `\times`。 -/


/-! ## 3. 写法 vs 本名：`×` 其实就是 `Prod`

    下面这两行**输出完全相同**——你输入 `Prod Nat Nat`，
    Lean 回给你 `Nat × Nat`。（回忆第 1 课：`true` 的本名是 `Bool.true`） -/

#check Prod Nat Nat     -- Nat × Nat : Type   ← 输入 Prod，输出 ×


/-! ## 4. 箭头是**右结合**的

    `Nat → Nat → Nat` 读作 `Nat → (Nat → Nat)`，所以下面两行是同一个类型。
    注意第二行：**我打了括号，Lean 把括号去掉了**——因为右结合时括号是多余的。 -/

#check Nat → Nat → Nat      -- Nat → Nat → Nat : Type
#check Nat → (Nat → Nat)    -- Nat → Nat → Nat : Type   ← 括号被去掉了


/-! ## 5. 函数也是「值」

    类型有了，还要有值。`Nat.succ`（加一）和 `Nat.add`（加法）都是现成的。 -/

#check Nat.succ         -- Nat.succ (n : Nat) : Nat
#check Nat.add          -- Nat.add : Nat → Nat → Nat

/-! ⚠️ 注意这两行的**显示方式不一样**：
    · `Nat.succ` 显示成 `Nat.succ (n : Nat) : Nat` —— 带了参数名 `n`
    · `Nat.add`  显示成 `Nat.add : Nat → Nat → Nat` —— 只有箭头
    两者意思一样（都是「吃 Nat 吐 Nat」），只是定义时的写法不同。
    **别被显示形式吓到，看箭头的个数就知道它吃几个参数。** -/


/-! ## 6. 部分应用：喂一半参数，得到一个函数

    `Nat.add` 要吃**两个**自然数。只喂一个呢？——得到一个新函数。 -/

#check Nat.add 3        -- Nat.add 3 : Nat → Nat
#eval Nat.add 5 2       -- 7


/-! ## 7. 对的值：用括号写，用 `.1` / `.2` 取

    `.1` 取第一个，`.2` 取第二个。（`.fst` / `.snd` 是同样的意思） -/

#check (5, 9)           -- (5, 9) : Nat × Nat
#eval (5, 9).1          -- 5
#eval (5, 9).2          -- 9
#check (5, 9).fst       -- (5, 9).fst : Nat
