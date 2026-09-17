/-
  Lean4Practice — 最小可编译基线（冒烟测试）

  这个文件的目的**不是学习知识**，而是证明下面这条链路真的能跑通：

  Windows 挂载盘上的源码（/mnt/e）
      + Linux 侧的 elan 工具链（~/.elan）
      + 符号链接到 Linux 侧的构建缓存（.lake）
      →  `lake build` 成功

  它只依赖 Lean 4 核心，**不依赖 mathlib**。
  只要能编译通过，就说明 AGENTS.md 的 D1 决策成立。
-/

/-- 最基础的等式证明：加法右单位元。-/
theorem add_zero_example (n : Nat) : n + 0 = n := rfl

/-- 字面量计算，确认 `rfl` 与数字字面量正常工作。-/
theorem one_add_one : 1 + 1 = 2 := rfl

/-- 命题逻辑：肯定前件（modus ponens）。-/
example (p q : Prop) (hp : p) (h : p → q) : q := h hp

/-- 一个小小的归纳证明，确认归纳策略可用。-/
theorem zero_add_example (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]
