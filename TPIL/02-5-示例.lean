/-
  第 2 章 · 第 5 课：定义（`def`）
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `02-5-习题.lean`。

  检查本文件：
    lake env lean TPIL/02-5-示例.lean
-/

/-! ## 1. `def` 就是「给一个东西起名字」

    你从第 1 课起就一直在用 `def`。这一课把它讲全：句型、能省什么、右边能放什么。 -/

def doubleA (x : Nat) : Nat := x + x     -- 参数写在 def 上
def doubleB : Nat → Nat := fun x => x + x -- 类型写全，右边是 fun
def doubleC := fun (x : Nat) => x + x     -- 类型全省，让 Lean 推

/-! 三个**是同一个函数**（`#eval` 全得 `6`），只是写法不同： -/

#check doubleA        -- doubleA (x : Nat) : Nat
#check doubleB        -- doubleB : Nat → Nat
#check doubleC        -- doubleC (x : Nat) : Nat

#eval doubleA 3       -- 6
#eval doubleB 3       -- 6
#eval doubleC 3       -- 6

/-! ⚠️ 注意 `#check` 的**显示形状**有两种——`doubleA`、`doubleC` 是望远镜式，`doubleB` 是箭头式。
    这正是 02-2 第 8 节讲过的：**取决于类型里的 binder 有没有名字**。
    （`doubleB` 的类型是我们手写的 `Nat → Nat`，参数没名字；另两个的类型里带着名字 `x`。） -/

/-! ## 2. 等号右边可以是**任何表达式**，不只是 `fun`

    原文原话：右边 `bar` 可以是任何表达式，所以 `def` 也能用来**给一个值起名字**。 -/

def pi := 3.141592654        -- 右边是一个小数
#check pi             -- pi : Float
#eval pi              -- 3.141593   ← 小数（Float）类型，Lean 内置

def square (x : Nat) : Nat := x * x   -- 右边是一个算式
#check square         -- square (x : Nat) : Nat
#eval square 4        -- 16

/-! ## 3. 多个参数：两种标注写法，同一个类型

    · 共用一个标注：`(x y : Nat)`
    · 分开写标注：`(x : Nat) (y : Nat)` -/

def addA (x y : Nat) := x + y
def addB (x : Nat) (y : Nat) := x + y

#check addA           -- addA (x y : Nat) : Nat
#check addB           -- addB (x y : Nat) : Nat   ← 和上一行输出相同

#eval addA 3 2        -- 5
#eval addB (doubleA 3) (7 + 9)   -- 22   ← 参数位置上可以放表达式

/-! ## 4. 参数也可以是函数

    （02-4 第 8 节已经见过「函数当参数」；这里是同一个东西，只是用 `def` 的句型写出来。） -/

def doTwice (f : Nat → Nat) (x : Nat) : Nat := f (f x)

#check doTwice        -- doTwice (f : Nat → Nat) (x : Nat) : Nat
#eval doTwice doubleA 2   -- 8   ← 先 2+2=4，再 4+4=8

/-! ## 5. `def` 起的名字与它的定义是什么关系（本课最抽象的一节）

    `Natural` 只是 `Nat` 的**另一个名字**。注意下面 `#check` 的结果：
    Lean **不会**把 `Natural` 换成 `Nat` 显示——**名字在大多数场合不被展开**。 -/

def Natural := Nat

#check Natural        -- Natural : Type
def idNat : Natural → Natural := fun n => n
#check idNat          -- idNat : Natural → Natural   ← 显示里保留的是 Natural，不是 Nat

/-! 可是**把 `Nat` 的东西塞进去却能通过**——因为 Lean 在**必须判断「两个东西是否按定义相等」**时，
    会**展开** `Natural`： -/

def three : Nat := 3
#eval idNat three     -- 3   ← 通过了：判断类型时 Natural 被展开成 Nat

/-! 这个「大多数场合不展开、必要时才展开」的性质叫 **半可归约**（semireducible）。
    ⚠️ 反过来「给 `Natural` 类型的东西直接写数字」**会报错**——那条报错涉及本课不引入的机制，
    原文与解释见讲义第 5 节（这里不放，免得示例文件出现 error）。 -/
