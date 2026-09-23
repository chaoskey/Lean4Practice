/-
  第 3 章 · 第 2 课 · 习题：第一个证明

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 这是你第一次真正写证明
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-2-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：证明 `p → p`。
    提示：讲义 §1 那个证明的「最简版」——只有一层假设。 -/
theorem ex1 (p : Prop) : p → p :=
  fun hp : p => hp

/- 题 2：证明 `p → q → q`。
    ⚠️ 这个证明**用不上** `p` 的证明——所以你会遇到讲义 §4 那个 warning。
       想清楚该怎么改，再动手。 -/
theorem ex2 (p q : Prop) : p → q → q :=
  fun _hp : p => fun hq : q => hq

/- 题 3：证明 `(p → q → r) → q → p → r`。
    提示：假设的名字先取好——第一个假设是个**吃两个参数**的函数，
          而你要喂给它的两个事实**顺序是反的**。 -/
theorem ex3 (p q r : Prop) : (p → q → r) → q → p → r :=
  fun hf : (p → q → r) => fun hq : q => fun hp : p => hf hp hq


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：`theorem` 和 `def` 有什么**相同**、有什么**不同**？
    （相同至少说一点，不同至少说一点——讲义 §2、§5 都有。）

    我的答案：相同点就是，如果 `theorem` 成立，那么将 `theorem` 简单改成 `def` 必然也成立； 不同点就是， 如果 `def` 成立，那么将 `def` 简单改成 `theorem` 不一定成立 ，但是如果 def 冒号后面的那个类型本身是命题 时，那么就一定成立。-/


/- 题 5：`show p from hp` 里的 **`show … from …`** 起什么作用？
    它**改变了证明本身**吗？

    我的答案：不会改变证明本身，只是说明 项 `hp` 的类型是 `p` 而已。 -/


/- 题 6：下面两种写法**有什么区别**？
    ① `theorem t (hp : p) (_hq : q) : p := hp`
    ② `theorem t : p → q → p := fun hp : p => fun _ : q => hp`

    我的答案： 没有任何区别，仅仅是两种不同写法而已， 前者是 望远镜式，后者是箭头式而已。-/


/- 题 7：原文说：`def` 会把**用到的** section 变量加成参数，
    而 `theorem` **只把「出现在类型里的」**变量加成参数。
    原文给的理由是「**怎么证不应该影响证的是什么**」——请说说你对这句话的理解。

    我的答案：否则定理的使用者会由于无关的条件而困恼！ -/


/- 题 8：`#print ex1` 打印出来的**类型**部分会是 `∀ (p : Prop), p → p` 这种形状。
    这里的 **`∀`** 和什么东西是**一回事**？（提示：02-9 预告过。）

    我的答案：∀ 就是 02-9 学的「依赖函数类型」 (x : α) → β x 的另一种写法。所以 ∀ (p : Prop), p → p 读作「对任意命题 p，都有 p → p」，而冒号后的 p → p 里含着 p——结果类型依赖前面的变量，这正是「依赖」两个字的由来。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。

#print ex1 -- theorem ex1 : ∀ (p : Prop), p → p := fun hp : p => hp
#print ex2 -- theorem ex2 : ∀ (p q : Prop), p → q → q := fun _hp : p => fun hq : q => hq
#print ex3 -- theorem ex3 : ∀ (p q r : Prop), (p → q → r) → q → p → r := fun hf : (p → q → r) => fun hq : q => fun hp : p => hf hp hq

#check ex1  -- ex1 : ∀ (p : Prop), p → p
#check ex2  -- ex2 : ∀ (p q : Prop), p → q → q
#check ex3  -- ex3 : ∀ (p q r : Prop), (p → q → r) → q → p → r

-- 额外核对（讲义 §3~§5 的那些现象）：
variable {p q : Prop}
theorem t1 : p → q → p := fun hp : p => fun _ : q => hp
#print t1 -- theorem t1 : ∀ {p q : Prop}, p → q → p := fun {p q} hp x => hp
#check (fun (x : Nat) => fun (_y : Bool) => x) -- (fun (x : Nat) => fun (_y : Bool) => x) : Nat → Bool → Nat
#check (fun (hp : p) => fun (_ : q) => hp) -- (fun (hp : p) => fun (_ : q) => hp) : p → q → p
