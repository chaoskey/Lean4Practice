/-
  第 3 章 · 第 2 课：第一个证明
  示范示例（全部已通过 Lean 编译，零 warning）

  ⚠️ 这是**我的**示例，不是你的习题。你的习题在 `03-2-习题.lean`。

  检查本文件：
    lake env lean TPIL/03-2-示例.lean
-/

section
  variable {p q r : Prop}

/-! ## 1. 第一个证明（层层 `fun`） -/

theorem t1 : p → q → p := fun hp : p => fun _ : q => hp

-- 与「类型版」对照：**形状完全一样**，只有 `Prop` 与 `Type` 的差别
#check (fun (x : Nat) => fun (_ : Bool) => x)    -- fun x x_1 => x : Nat → Bool → Nat
#check (fun (hp : p) => fun (_ : q) => hp)       -- fun hp x => hp : p → q → p

/-! ## 2. 同一件事的另外两种写法（都产生同一个项） -/

theorem t1c (hp : p) (_hq : q) : p := hp
theorem t1d : p → q → p := fun hp _ => hp

/-! ## 3. `#print`：Lean 记下的真正形状 -/

#print t1
-- theorem t1 : ∀ {p q : Prop}, p → q → p :=
-- fun {p q} hp x => hp

#print t1c
#print t1d

/-! ## 4. `show … from …` 只做「标注」（不改变证明） -/

theorem t1e : p → q → p :=
  fun hp : p =>
  fun _ : q =>
  show p from hp

#print t1e
-- 内部变成 `have this := hp; this` —— `have` 属 3-7

/-! ## 5. 把定理当函数用（应用） -/

theorem t2 (hp : p) : q → p := t1 hp

#check t2          -- t2 {p q : Prop} (hp : p) : q → p
#print t2

/-! ## 6. 综合例子：复合（推理的传递性） -/

theorem comp (h₁ : q → r) (h₂ : p → q) : p → r :=
  fun h₃ : p =>
  show r from h₁ (h₂ h₃)

#print comp

end

/-! ## 7. 泛化以后，复用到不同的命题对 -/

section
  variable (p q r s : Prop)

  theorem t1' (p q : Prop) (hp : p) (_hq : q) : p := hp

  #check t1' p q              -- t1' p q : p → q → p
  #check t1' r s              -- t1' r s : r → s → r
  #check t1' (r → s) (s → r)  -- t1' (r → s) (s → r) : (r → s) → (s → r) → r → s
end

/-! ## 8. 本课不引入的东西

    · `axiom` —— 原文用它演示「把定理当函数用」，但它可能破坏一致性
    · `∀` 的完整讲解 —— 第 4 章（本课只要认得它 = 依赖函数类型）
    · `have` —— 3-7
    · tactic（`rw` / `simp` / `apply`…）—— 后面几课 -/
