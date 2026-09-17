/-
  第 2 章 · 第 1 课：每个表达式都有一个类型
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-1-习题.lean`。

  检查本文件：
    export PATH="$HOME/.elan/bin:$PATH"
    lake env lean TPIL/02-1-示例.lean
-/

/-! ## 1. 用 `def` 声明常量

    句式：   def 名字 : 类型 := 值
    `:=` 读作「定义为」。 -/

def m : Nat := 1
def n : Nat := 0
def b1 : Bool := true
def b2 : Bool := false


/-! ## 2. `#check` —— 问「它是什么类型？」

    输出格式**永远是**：  表达式 : 类型 -/

#check m            -- m : Nat
#check n            -- n : Nat
#check m + n        -- m + n : Nat
#check b1           -- b1 : Bool
#check b1 && b2     -- b1 && b2 : Bool
#check true         -- Bool.true : Bool   ← ⚠️ 见下方说明


/-! ## 3. `#eval` —— 问「它等于多少？」

    注意：`#eval` 只打印**值**，不打印类型。 -/

#eval 5 * 4         -- 20
#eval m + 2         -- 3
#eval b1 && b2      -- false


/-! ## 3.5 一个会让人困惑的细节

    上面 `#check true` 打印的是 `Bool.true : Bool`，**而不是** `true : Bool`。
    你写的是 `true`，Lean 回给你的是 `Bool.true`。

    为什么？因为 `true` 只是**写法（记号）**，它真正的名字叫 `Bool.true`。
    `#check` 有时会把你的写法**还原成完整名字**再打印。

    ⚠️ 所以：**输出的样子不必和输入一模一样**。看到不认识的完整名字时，
    想想它是不是某个你熟悉的写法的「本名」。 -/


/-! ## 4. 两种注释 -/

-- 两个减号：这一行剩下的部分是注释

/- 斜杠星号：块注释，可以跨很多行 -/

/- 块注释还可以嵌套（别的语言里很少见）：
   /- 我是内层 -/
   外层继续
-/
