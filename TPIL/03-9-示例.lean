/-
  第 3 章 · 第 9 课 · 示范：命题有效性的综合演练

  本文件对应讲义 §6、§7、§8。
  ⚠️ 要求：**零警告、零错误**（见 D9 / D12）。

  ⚠️ 本文件里**绝不能出现活动的 `sorry`**——那会引入 `sorryAx` 并报警告。
     `sorry` 和 `_` 的演示**全部放在注释里**（讲义 §4、§5 有完整说明）。
-/

/- ============ 一、样板一：分配律（**不需要**经典）============

   讲义 §6 逐段拆过这个证明，这里只放成品。
   注意整段的形状：目标是 `↔` → `Iff.intro` 交两个方向。 -/

theorem distrib (p q r : Prop) : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) :=
  Iff.intro
    (fun h : p ∧ (q ∨ r) =>
      have hp : p := h.left
      Or.elim h.right
        (fun hq : q => show (p ∧ q) ∨ (p ∧ r) from Or.inl ⟨hp, hq⟩)
        (fun hr : r => show (p ∧ q) ∨ (p ∧ r) from Or.inr ⟨hp, hr⟩))
    (fun h : (p ∧ q) ∨ (p ∧ r) =>
      Or.elim h
        (fun hpq : p ∧ q =>
          have hp : p := hpq.left
          have hq : q := hpq.right
          show p ∧ (q ∨ r) from ⟨hp, Or.inl hq⟩)
        (fun hpr : p ∧ r =>
          have hp : p := hpr.left
          have hr : r := hpr.right
          show p ∧ (q ∨ r) from ⟨hp, Or.inr hr⟩))

-- 它用没用经典？—— 只看这一行，不看别的
#print axioms distrib


/- ============ 二、又一个**不需要**经典的例子：`¬(p ∧ ¬p)` ============

   讲义 §8 的判准表里列了它。
   注意：这里的 `h.right` 的类型是 `¬p`，也就是 `p → False`，
   所以 `h.right h.left` 就是「把 `p` 的证明喂给 `¬p`」，得到 `False`。 -/

theorem not_both (p : Prop) : ¬(p ∧ ¬p) :=
  fun h : p ∧ ¬p => h.right h.left

#print axioms not_both


/- ============ 三、样板二：`¬(p ∧ ¬q) → (p → q)`（**需要**经典）============

   ⚠️ 注意 `open Classical` **放在这里**，而不是文件最顶上。
      讲义 §7.4、§8.1 讲过为什么这件事要紧：
      `open Classical` 一旦写在文件顶部，**它下面每一个定理都能沾上经典**，
      于是「能编译」就不再能说明「没用到经典」。 -/

open Classical

theorem not_and_not (p q : Prop) : ¬(p ∧ ¬q) → (p → q) :=
  fun h : ¬(p ∧ ¬q) =>
  fun hp : p =>
  show q from
  Or.elim (em q)
    (fun hq : q => hq)
    (fun hnq : ¬q => absurd (And.intro hp hnq) h)

-- 和上面两条对照着看：这一条**带着经典**
#print axioms not_and_not


/- ============ 四、经典逻辑的「入口」自己就带着经典 ============

   `em p` 就是 `p ∨ ¬p`，它就是那条公理本身。 -/

theorem em_demo (p : Prop) : p ∨ ¬p :=
  em p

#print axioms em_demo


/- ============ 五、`sorry` 和 `_` 的演示（**只放注释**）============

   ⚠️ 下面这些**故意**留着注释，原因有两个：
     ① `sorry` 会报警告 → 本文件必须零警告；
     ② `_` 会直接报错 → 放进来就编译不过。
   想亲手试，把它们复制到**临时文件**里跑（别改本文件）。

   ---- `sorry`：能编译，但会留警告 + `sorryAx` ----

     theorem scaffold (p q : Prop) : p → q :=
       sorry

     -- warning: declaration uses `sorry`
     -- #print axioms scaffold
     -- → 'scaffold' depends on axioms: [sorryAx]        ← 所以它**不是**证明

   ---- `_`：让 Lean 报出「它要什么」（**通常直接失败**）----

     example (p : Prop) (h : p) : p := _
     -- error: don't know how to synthesize placeholder

     example (p : Prop) (h : p) : p ∧ p := ⟨_, _⟩
     -- error: don't know how to synthesize placeholder for argument `right`
     --        （这句话顺带告诉你：**是右半没填上**）

   ✅ 对照：`_` 在**隐式参数**的位置是**会成功**的
      （2-10 学过；这里不重复，免得和上面四条混起来）。
-/
