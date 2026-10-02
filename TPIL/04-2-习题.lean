/-
  第 4 章 · 第 2 课 · 习题：量词的 `#check` 阶梯与隐式参数

  规则：
    · 题 1、2、5、6：**写证明**（把 `sorry` 换掉），用证明项，**不要用 tactic**
    · 题 3、4：**先预测、再核对**——预测写在题面的注释里，
               核对时到文件末尾「验证区」，把对应那几行前面的 `--` 删掉
    · 本文件里**一处 `sorry` 都不能留**

  检查：
    lake env lean TPIL/04-2-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
  ⚠️ **验收脚本的 ✅ 只覆盖题 1、2、5、6**——题 3、4 的答案写在注释里，脚本看不见，
     那两道题由批改时人工核对（见讲义 §8）。
-/

variable (α : Type) (r : α → α → Prop)

/- ============================================================
   题 1：把两个前提接起来。
   ============================================================ -/

/- 已知（**写在下面这道题的参数表里了**）：
     trans_r : ∀ {x y z}, r x y → r y z → r x z      （传递性；花括号 = 隐式参数）
   手上有：hab : r a b 与 hbc : r b c。
   要证：r a c。

   提示：讲义 §3 讲的隐式参数，好处就是你**不用**写 `a b c`。

   我的答案： -/
theorem ex1 (trans_r : ∀ {x y z}, r x y → r y z → r x z)
    (a b c : α) (hab : r a b) (hbc : r b c) : r a c :=
  trans_r hab hbc

/- ============================================================
   题 2：三个前提，中间还要换一次方向。
   ============================================================ -/

/- 已知：
     symm_r  : ∀ {x y}, r x y → r y x                  （对称性）
     trans_r : ∀ {x y z}, r x y → r y z → r x z        （传递性）
   手上有：hba : r b a、hbc : r b c、hcd : r c d。
   要证：r a d。

   提示：先把 `hba` 掉个头，再把三截接成 a → d。
         讲义 §4 的做法是「一个 `trans_r` 里套另一个」（也可以套成别的形状，只要接得上）。

   我的答案： -/
theorem ex2 (symm_r : ∀ {x y}, r x y → r y x) (trans_r : ∀ {x y z}, r x y → r y z → r x z)
    (a b c d : α) (hba : r b a) (hbc : r b c) (hcd : r c d) : r a d :=
  trans_r (trans_r (symm_r hba) hbc) hcd

/- ============================================================
   题 3、4 共用下面这些声明（验证区的 `#check` 要用它们）
   ============================================================ -/

variable (u v w z : α)
variable (huv : r u v) (hvw : r v w) (hwz : r w z)
variable (chain : ∀ x y z w, r x y → r y z → r z w → r x w)
variable (chainI : ∀ {x y z w}, r x y → r y z → r z w → r x w)

/- ============================================================
   题 3：**先预测、再核对**（参数是显式的）
   ============================================================ -/

/- 讲义 §2 用 `trans_r`（**三个**值参数）演示了 `#check` 阶梯。
   本题换一张定理：`chain` 有**四个**值参数（它的类型见上面那行 `variable`）。

   请预测下面 5 条 `#check` 的输出，照 Lean 打印的格式写：

     我的预测：
       #check chain                        → chain : ∀ (x y z w : α), r x y → r y z → r z w → r x w
       #check chain u v w z                → chain u v w z : r u v → r v w → r w z → r u z
       #check chain u v w z huv            → chain u v w z huv : r v w → r w z → r u z
       #check chain u v w z huv hvw        → chain u v w z huv hvw : r w z → r u z
       #check chain u v w z huv hvw hwz    → chain u v w z huv hvw hwz : r u z

   核对方法：到文件末尾「验证区」，把题 3 那 5 行前面的 `--` 删掉，重新跑检查命令。
   ⚠️ 核对完，把你预测的注释**改成与真实输出一致**（这是规矩）。

   我的答案： -/

/- ============================================================
   题 4：**先预测、再核对**（参数是隐式的），外加一问
   ============================================================ -/

/- 这次把同一张定理的值参数写成**隐式**（`chainI`）。

   ① 预测下面 4 条 `#check` 的输出：

     我的预测：
       #check chainI                        →  chainI : r ?_ ?_ → r ?_ ?_ → r ?_ ?_ → r ?_ ?_
       #check chainI huv                    →  chainI huv : r v ?_ → r ?_ ?_ → r u ?_
       #check chainI huv hvw                →  chainI huv hvw : r w ?_ → r u ?_
       #check chainI huv hvw hwz            →  chainI huv hvw hwz : r u z

   ② 用一句话答：`#check chainI` 那一行里出现了 `?m`，而最后一行里没有——
      **这个差别是从哪里来的？**

     我的答案（②）：因为  `?m` 对于的类型 Lean 4 无法自动推导出来，所以只能用这个占位。 而最后一行 的所有类型都可以自动推导出来。

   核对方法：到文件末尾「验证区」，把题 4 那 4 行前面的 `--` 删掉，重新跑检查命令。

   我的答案： -/

/- ============================================================
   题 5：把隐式参数**显式**写出来。
   ============================================================ -/

/- 已知：symm_r : ∀ {x y}, r x y → r y x
   手上有：hab : r a b。要证：r b a。

   ⚠️ 约束：**不许**写 `symm_r hab`——请用讲义 §3.5 讲的 `@` 写法，
      把 `symm_r` 的两个值参数**显式**写出来。

   我的答案： -/
theorem ex5 (symm_r : ∀ {x y}, r x y → r y x) (a b : α) (hab : r a b) : r b a :=
  @symm_r a b hab

/- ============================================================
   题 6：把讲义 §5 的结论从「命题」搬到「类型」上。
   ============================================================ -/

/- 讲义 §5 说：`p → q` 就是 `∀ _ : p, q`（**按定义是同一个类型**）。

   现在把讲义 §5 的那句话（`p → q` 就是 `∀ _ : p, q`）里的**命题**换成**类型**，再说一遍：
   `α → β` 就是 `∀ _ : α, β`。

   请把下面两个 `example` 的 `sorry` 换掉——每个都只用**一次直接赋值**
   （不要写 `fun`；写完你会看出它和讲义 §5 是同一件事）。

   我的答案： -/
example (α β : Type) (f : α → β) : ∀ _ : α, β :=
   f

example (α β : Type) (f : ∀ _ : α, β) : α → β :=
   f


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- 题 3（显式阶梯）：
#check chain                     -- chain : ∀ (x y z w : α), r x y → r y z → r z w → r x w
#check chain u v w z             -- chain u v w z : r u v → r v w → r w z → r u z
#check chain u v w z huv         -- chain u v w z huv : r v w → r w z → r u z
#check chain u v w z huv hvw     -- chain u v w z huv hvw : r w z → r u z
#check chain u v w z huv hvw hwz -- chain u v w z huv hvw hwz : r u z
--
-- 题 4（隐式阶梯）：
#check chainI              -- chainI : r ?m.9 ?m.10 → r ?m.10 ?m.11 → r ?m.11 ?m.12 → r ?m.9 ?m.12
#check chainI huv          -- chainI huv : r v ?m.11 → r ?m.11 ?m.12 → r u ?m.12
#check chainI huv hvw      -- chainI huv hvw : r w ?m.12 → r u ?m.12
#check chainI huv hvw hwz  -- chainI huv hvw hwz : r u z
--
-- 逐题查公理：把下面几行取消注释，然后跑检查命令。
#print axioms ex1    -- 'ex1' does not depend on any axioms
#print axioms ex2    -- 'ex2' does not depend on any axioms
#print axioms ex5    -- 'ex5' does not depend on any axioms
