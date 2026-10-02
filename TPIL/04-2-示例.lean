/-
  第 4 章 · 第 2 课 · 示例：量词的 `#check` 阶梯、隐式参数

  我写的示范。已验证：**零错误、零警告**。

  ⚠️ 这四组例子**都不是** `04-2-习题.lean` 里的题目——
     习题用的是另外的定理名（`chain` / `chainI`）和另外的变量名。
-/

variable (α : Type) (r : α → α → Prop)

/- ============================================================
   例 A：`#check` 阶梯（参数是**显式**的）
   —— 演示「每喂一个参数，类型就短一截」
   ============================================================ -/
section exA
variable (trans_r : ∀ x y z, r x y → r y z → r x z)
variable (a b c : α)
variable (hab : r a b) (hbc : r b c)

#check trans_r
#check trans_r a b c
#check trans_r a b c hab
#check trans_r a b c hab hbc
end exA

/- 逐条读（这就是「阶梯」）：

     #check trans_r              →  r ?  ?  → r ?  ?  → r ?  ?     三个值都还没给
     #check trans_r a b c        →  r a b → r b c → r a c         三个值给了，剩两个前提
     #check trans_r a b c hab    →  r b c → r a c                 喂掉一个前提
     #check trans_r a b c hab hbc→  r a c                         前提喂完，剩下的是**结论**

   ⚠️ 最要紧的一点：**最后一行左边已经不是函数了**——它就是要证的命题本身。
      这就是 04-1 学的「消去」：应用一次，少一个前提。
-/

/- ============================================================
   例 B：同一张定理，值参数改成**隐式**
   —— 演示「写作时省事」与「单独看时信息不足」
   ============================================================ -/
section exB
variable (trans_i : ∀ {x y z}, r x y → r y z → r x z)
variable (a b c : α)
variable (hab : r a b) (hbc : r b c)

#check trans_i
#check trans_i hab
#check trans_i hab hbc
end exB

/- 逐条读：

     #check trans_i        →  r ?m.4 ?m.5 → r ?m.5 ?m.6 → r ?m.4 ?m.6
     #check trans_i hab    →  r b ?m.6 → r a ?m.6
     #check trans_i hab hbc→  r a c

   ⚠️ `?m.4` 这类记号（**元变量**）是「Lean 到这里还不知道该填什么」。
      它是 02-4 讲过的 `?m.N` 的同一种东西。
      信息是从**喂进去的那些参数的类型**来的：
        `hab : r a b` 把第一、二个值钉成 `a`、`b`；
        `hbc : r b c` 把第三个钉成 `c` —— 三个都钉住了，`?m` 就没了。

   📌 好处：写起来短（不用写 `a b c`）。
      代价：单独看 `trans_i` / `trans_i hab` 时，Lean 给不出完整信息。
-/

/- ============================================================
   例 C：等价关系的初等推理（原文 4.1 的例子）
   —— 演示「把两个引理接起来」
   ============================================================ -/
theorem exC (symm_r : ∀ {x y}, r x y → r y x) (trans_r : ∀ {x y z}, r x y → r y z → r x z)
    (a b c d : α) (hab : r a b) (hcb : r c b) (hcd : r c d) : r a d :=
  trans_r (trans_r hab (symm_r hcb)) hcd

/- 逐步看类型（每一步都是「消去」）：

     hab                : r a b
     hcb                : r c b
     symm_r hcb         : r b c            ← 把 hcb 掉个头
     trans_r hab (…)    : r a c            ← 接上第一截
     hcd                : r c d
     trans_r (…) hcd    : r a d            ← 再接上第三截

   ⚠️ 这里 `symm_r` / `trans_r` 是**写成显式参数**的（在 `theorem` 的参数表里）。
      为什么不写成 `variable` 让 Lean 自动加？见讲义 §4 末尾那个 ⚠️——**会踩坑**。
-/

/- ============================================================
   例 D：`p → q` 就是 `∀ _ : p, q`
   —— 演示「第 3 章的 `→` 是第 4 章 `∀` 的特例」
   ============================================================ -/
theorem exD1 (p q : Prop) (h : p → q) : ∀ _ : p, q := h
theorem exD2 (p q : Prop) (h : ∀ _ : p, q) : p → q := h

/- 两个方向都是**直接赋值**（`:= h`），不需要 `fun`、不需要任何转换——
   这说明两个类型**按定义就是同一个**（不是「等价」，是「同一个」）。
-/

/- ============================================================
   例 E：用 `@` 把隐式参数**显式**写出来
   ============================================================ -/
theorem exE (symm_r : ∀ {x y}, r x y → r y x) (a b : α) (hab : r a b) : r b a :=
  @symm_r a b hab

/- `@` 的作用（2-10 讲过）：把**所有**隐式参数变成必须写的显式参数。
       `symm_r hab`        ← 不写值参数（靠推断）
       `@symm_r a b hab`   ← 把 `x y` 写成 `a b`（不再推断）

   📌 `@symm_r` 后面**必须**把隐式参数一个不落地写出来；
      只写一部分（如 `@symm_r a`）不合法。
-/

/- ============================================================
   公理体检：本课全部是构造性的
   ============================================================ -/
#print axioms exC
#print axioms exD1
#print axioms exD2
#print axioms exE
