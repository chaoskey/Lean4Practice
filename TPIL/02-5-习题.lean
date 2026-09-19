/-
  第 2 章 · 第 5 课 · 习题：定义（`def`）

  规则：
    · 前三题：把 `sorry` 换成你的定义
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-5-习题.lean

  ⚠️ 这一课讲的都是 `def` 本身，所以前三题请**用 `def` 写**。
  ⚠️ 第 5 题问的是「**不写类型**」的写法——那是这一课的一个重点。

  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、用 `def` 写定义（把 sorry 换掉）============ -/

/-- 题 1：用 `def` 定义 `inc`：把自然数**加一**。
    要求：参数写在 `def` 上，并且**类型标注写全**（照讲义第 1 节的 `doubleA` 那种句型写）。 -/
def inc (n : Nat) : Nat :=
  n + 1

/-- 题 2：用 `def` 定义一个常量 `myAnswer`，类型是 `Nat`，**值是一个算式** `6 * 7`
    （不要直接写 `42`——本题考的就是「右边可以放表达式」）。 -/
def myAnswer : Nat :=
  6 * 7

/-- 题 3：用 `def` 定义 `apply3`：它吃一个函数 `f : Nat → Nat` 和一个 `x : Nat`，
    把 `f` **连着用三次**（即 `f (f (f x))`）。
    提示：讲义第 4 节的 `doTwice` 是「用两次」，把它改成三次。 -/
def apply3 (f : Nat → Nat) (x : Nat) : Nat :=
  f (f (f x))


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：下面两个定义，写出来的**是同一个函数**吗？它们的**类型**一样吗？
        `#check` 打印出来的**形状**一样吗？请分别说明。

      def f : Nat → Nat := fun x => x + 1
      def g (x : Nat) : Nat := x + 1

    我的答案：是同一个函数。类型也是一样的。但是形状不一样。前者是：f : Nat → Nat ； 后者是 g (x : Nat) : Nat -/


/- 题 5：下面这个定义**没有写类型**，让 Lean 自己推。

      def double := fun (x : Nat) => x + x

    问：`#check double` 会打印成什么形状？（连 `: ...` 一起写）

    我的答案：double (x : Nat) : Nat -/


/- 题 6：下面这个定义**也没有写类型**。

      def add (x y : Nat) := x + y

    问：`#check add` 会打印成什么？（连 `: ...` 一起写）

    我的答案： add (x y : Nat) : Nat -/


/- 题 7：先做下面这个定义（它给 `Nat` 起了个新名字）：

      def Natural := Nat

    然后这一行**能通过吗**？

      def five : Natural := 5

    请回答「能不能通过」，并说明：这体现了 `def` 起的名字在大多数场合
    **会不会被展开**？

    我的答案：不能通过, 只有在判断是否相等的时候，才会将这个类型定义进行展开，这属于半规约定义。在这里不是这种情况，所以不通过。 -/


/- 题 8：`def Natural := Nat` 之后，下面这些**却能通过**：

      def idNat : Natural → Natural := fun n => n
      def three : Nat := 3
      #eval idNat three     -- 结果是 3

    问：为什么把 `Nat` 的 `three` 塞进要 `Natural` 的地方**可以**？（用讲义第 5 节那个词回答也行）

    我的答案：因为在判断表达式是否相等的时候，是会将定义进行展开，而展开的结果它们是同一个，所以可以。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，答案就直接印出来了。
-- ⚠️ 带 `#eval` 的那几行要等你把前三题做完再取消注释
--    （`#eval` 不能对含 `sorry` 的东西求值）。

#check inc   -- inc (n : Nat) : Nat
#check myAnswer -- myAnswer : Nat
#check apply3  -- apply3 (f : Nat → Nat) (x : Nat) : Nat
def f : Nat → Nat := fun x => x + 1
def g (x : Nat) : Nat := x + 1
#check f   -- f : Nat → Nat
#check g   -- g (x : Nat) : Nat
def double := fun (x : Nat) => x + x
#check double   -- double (x : Nat) : Nat
def add (x y : Nat) := x + y
#check add  -- add (x y : Nat) : Nat
def Natural := Nat
def idNat : Natural → Natural := fun n => n
def three : Nat := 3
#eval idNat three  -- True
#eval inc 5   -- 6
#eval myAnswer  -- 42
#eval apply3 (fun n => n * 2) 1  -- 8
