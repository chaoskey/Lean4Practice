/-
  第 2 章 · 第 3 课 · 习题：`Prop` 与 `Type`（类型本身也是对象）

  规则：
    · 前三题：把 `sorry` 换成你的定义
    · 后四题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/02-3-习题.lean

  ⚠️ 本课没学「自己造证明」——那是第 3 章的内容。
     所以前三题请用**讲义 / 示例里出现过的现成东西**（`Nat`、`True`、`List`）来填。

  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、用 `def` 写定义（把 sorry 换掉）============ -/

/-- 题 1：声明常量 `myType`，**它的类型是 `Type`**，值是 `Nat`。
    （也就是：给一个**类型**起个名字。） -/
def myType : Type :=
  Nat

/-- 题 2：声明常量 `myProp`，**它的类型是 `Prop`**，值是 `True`。 -/
def myProp : Prop :=
  True

/-- 题 3：声明常量 `myTypeFn`，**它的类型是 `Type → Type`**，
    让它表示「把一个类型变成它的列表类型」。
    提示：示例里有一个现成的、正好干这事的东西。 -/
def myTypeFn : Type → Type :=
  List


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：下面这一行会打印什么？（连 `: Type` 一起写）

      #check Bool

    我的答案：Bool : Type -/


/- 题 5：下面这一行会打印什么？

      #check Prop

    **另外**：`Prop` 自己是「类型」还是「命题」？

    我的答案：Prop : Type   ， 本身是类型 -/


/- 题 6：下面这一行会打印什么？

      #check True

    我的答案： True : Prop -/


/- 题 7：下面四个东西，哪些是「类型」、哪些是「命题」、哪些是「值」？
    （判据见讲义第 7 节）

      Nat × Bool        True        True.intro        Prop

    我的答案： 类型（ Nat x Bool : Type）,  命题（True : Prop）,  值(也是证明) , 类型( Prop : Type ) -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，答案就直接印出来了。

#check Bool
#check Prop
#check True
#check myType
#check myProp
#check myTypeFn
#check myTypeFn Nat
