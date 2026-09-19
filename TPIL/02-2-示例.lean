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

/-! ⚠️ 两行**显示方式不一样**，但先看清它们**真正**的区别——它们不是同一个函数：
    · `Nat.succ` —— 吃 **1 个** Nat：`Nat.succ (n : Nat) : Nat`
    · `Nat.add`  —— 吃 **2 个** Nat：`Nat.add : Nat → Nat → Nat`
    参数个数都不同，所以这本来就是两个不同的函数。

    本节要说的是**类型的两种排版**（它们指的是同一个类型）：
    · 望远镜式 `f (n : Nat) : Nat` —— 类型里给参数**起了名字**
    · 箭头式   `f : Nat → Nat`     —— 类型里的参数是**匿名的** `_`
    Lean 用哪种排版，只看当初声明时怎么写。 -/

-- 规律实测：下面每个 def 后面的注释就是 `#check` 的输出。
def a (n : Nat) : Nat := n + 1          -- #check a  →  a (n : Nat) : Nat
def b : Nat → Nat := fun n => n + 1     -- #check b  →  b : Nat → Nat
def c : (n : Nat) → Nat := fun n => n   -- #check c  →  c (n : Nat) : Nat
def g : (_ : Nat) → Nat := fun n => n   -- #check g  →  g : Nat → Nat  ← 名字是 _，算匿名

-- 上面四个 def 的 #check 实测（输出就在下面）：
#check a
#check b
#check c
#check g

/- 结论：**参数有名字 → 望远镜式；参数匿名（`_`）→ 箭头式**，纯粹是显示选择。
   同一声明换个命令也会变：`#check a` 是望远镜式，`#print a` 却是箭头式。
   所以**显示形式不能用来推断含义**，只看参数个数与类型。 -/

-- 两种写法确实是同一个类型：互相能塞进去，算出来的结果也一样。（下面 4 个数是实测输出）
def useArrow (f : Nat → Nat) : Nat := f 3
#eval useArrow a        -- 4      ← 望远镜式写出来的 a，照样当箭头式用
#eval useArrow b        -- 4
def useNamed (f : (x : Nat) → Nat) : Nat := f 4
#eval useNamed a        -- 5      ← 反过来也一样
#eval useNamed b        -- 5

/- 注：本来还可以写一句 `example : a = b := rfl`，用「相等」直接判定 a 和 b 是同一个函数。
   但那要用到 `=` 与 `rfl`——**属于第 3 章的内容，本课不引入**，所以这里不写。
   上面「互相能塞进去」已经足够说明两种写法是同一个类型了。 -/


/-! ## 6. 部分应用：喂一半参数，得到一个函数

    `Nat.add` 要吃**两个**自然数。只喂一个呢？——得到一个新函数。 -/

#check Nat.add 3        -- Nat.add 3 : Nat → Nat
#eval Nat.add 5 2       -- 7


/-! ## 7. 对的值：用括号写，用 `.1` / `.2` 取

    `.1` 取第一个，`.2` 取第二个。`.1` / `.2` 只是**记号**，本名是 `.fst` / `.snd`
    （跟 `×` 是本名 `Prod` 的记号同理），两种写法意思完全一样。

    ⚠️ **注意 `#check` 和 `#eval` 的区别**：`#check` 问「类型」，`#eval` 问「值」。
    所以 `#check (5, 9).fst` 只回 `Nat`，**看不到 5**；要看 5 必须用 `#eval`。 -/

#check (5, 9)           -- (5, 9) : Nat × Nat
#eval (5, 9).1          -- 5
#eval (5, 9).2          -- 9
#check (5, 9).fst       -- (5, 9).fst : Nat   ← 问类型，所以只回 Nat

#eval (5, 9).fst        -- 5                  ← 问值，才回 5
#eval (5, 9).snd        -- 9
#check (5, 9).1         -- (5, 9).fst : Nat   ← 输入 .1，Lean 打印成本名 .fst
