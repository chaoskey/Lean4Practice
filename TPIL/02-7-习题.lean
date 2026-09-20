/-
  第 2 章 · 第 7 课 · 习题：变量与区段（`variable` / `section`）

  规则：
    · 前三题：把 `sorry` 换成你的定义（题 1、题 2 还要**自己补上 `variable` 那一行**）
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-7-习题.lean

  ⚠️ 题 1、题 2 要求定义里**一个参数都不写**（这正是本课要考的东西）。
  ⚠️ 题 3 要求用 `section`。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、用 `variable` / `section` 写定义（把 sorry 换掉）============ -/

/- 题 1：先声明一个**文件级**变量 `n : Nat`（写在下面这个 `def` 的**上面**），
    再写一个 `def doubleN`——**一个参数都不写**——它的值是 `n + n`。
    （骨架里那个 `: Nat` 为什么这么写？讲义 §4 末尾专门讲了这个坑。）-/

variable (n : Nat)
def doubleN :=
  n + n

/- 题 2：再声明两个**文件级**变量 `(f : Nat → Nat)` 与 `(x : Nat)`，
    然后写两个**不写参数**的定义：`twice`（把 `f` 用两次）、`thrice`（把 `f` 用三次）。 -/
variable (f : Nat → Nat) (x : Nat)

def twice :=
  f (f x)

def thrice :=
  f (f (f x))

/- 题 3：用一对**匿名** `section` / `end`，把下面这个定义包起来：
    在 section 里声明一个变量 `m : Nat`，并在 section 里写一个**不写参数**的
    `def squareM`，它的值是 `m * m`。 -/
section
variable (m : Nat)
def squareM :=
  m * m
end


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：题 1 做完之后，`#print doubleN` 会打印出什么？
    （提示：`#check` 只给你类型；`#print` 会连**定义**一起给你。
      请把 `def … :=` 和后面的 `fun …` 都写出来。）

    我的答案：`#check`  给出 ： doubleN (n : Nat) : Nat
`#print` 给出
    def doubleN : Nat → Nat := fun n => n + n
-/


/- 题 5：如果声明了 `variable (n : Nat) (b : Bool)`，然后写

      def incN := n + 1

    问：`#print incN` 打印出来的定义里，**会不会**出现 `b`？为什么？

    我的答案：不会出现 b ，因为定义右边只用到 n 没有用到 b -/


/- 题 6：题 3 的 `section` 结束之后，下面两样东西**还能不能用**？请分别回答。

      ① `#check m`（section 里声明的那个**变量**）
      ② `#check squareM`（section 里定义的那个 **`def`**）

    我的答案：前者不能用； 后者可以用 -/


/- 题 7：命名 section（写成 `section 名字`）结束的时候，`end` 后面**必须**跟什么？
    如果故意写成**另一个名字**，会发生什么？

    我的答案：也必须使用同样的名字； 如果写成其他的会报错。 -/


/- 题 8：下面两段的效果一样吗？请分别写出它们**各自的类型**。

      -- A：
      def fA (g : Nat → Nat) (x : Nat) : Nat := g (g x)

      -- B：
      variable (g : Nat → Nat) (x : Nat)
      def fB := g (g x)

    我的答案：效果一样； 各自的类型都是 `(Nat → Nat) → Nat → Nat` -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 带 `#eval` 的那几行要等你把前三题做完再取消注释
--    （`#eval` 不能对含 `sorry` 的东西求值）。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#check doubleN -- doubleN (n : Nat) : Nat
#print doubleN -- def doubleN : Nat -> Nat fun n => n + n
#eval doubleN 3  -- 6

#check twice  -- twice (f : Nat → Nat) (x : Nat) : Nat
#print twice  -- def twice : (Nat -> Nat) -> Nat -> Nat fun f x => f (f x)
#check thrice -- thrice (f : Nat → Nat) (x : Nat) : Nat
#eval twice (fun k => k + 1) 51  -- 53

#check squareM  -- squareM (m : Nat) : Nat
#print squareM  -- def squareM : Nat -> Nat := fun m => m * m
#eval squareM 4   --16

-- 题 8 的对照（两段都写出来，自己比较 `#check` 的结果）：
def fA (g : Nat → Nat) (x : Nat) : Nat := g (g x)
variable (gg : Nat → Nat) (xx : Nat)
def fB := gg (gg xx)

#check fA  -- def fA : (Nat → Nat) → Nat → Nat
#check fB  -- def fB : (Nat → Nat) → Nat → Nat

-- ⚠️ 下面两段**取消注释会报错**，那是预期的（本课就是要你看到「变量失效」与「名字不对」）：
-- #check m  -- 不能用，section 里声明的变量在外部失效
-- section foo
--   variable (z : Nat)
--   def dz := z + 1
-- end bar  -- 报错，因为 section 名字不对
