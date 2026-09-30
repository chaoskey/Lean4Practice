/-
  第 3 章 · 第 8 课 · 习题：经典逻辑（排中律 / 双重否定消去 / 反证）

  规则：
    · 前三题：**写证明**（把 `sorry` 换掉）—— 用**证明项**写，不要用 tactic
    · 后五题：把**你的预测 / 判断**写在「我的答案：」后面
              —— 先自己判断，**再**运行验证。

  检查：
    lake env lean TPIL/03-8-习题.lean

  ⚠️ 题面一律用**普通注释** `/- … -/`（不是 `/-- … -/`）。
  ⚠️ `sorry` 要单独占一行，否则验收脚本检不出来。
-/

/- ============ 一、写三个证明 ============ -/

/- 题 1：已知 `h : ¬¬p`，证明 `p`。

    约束：**用 `byContradiction` 写**（不许直接拿 `em` 交差）。
          文件顶部**要自己写** `open Classical`。

    提示：反证要写的**只有**「**从 `¬p` 出发怎么推出矛盾**」那半句——
          你手上已经有 `h : ¬¬p`，它在等什么？

    我的答案： -/
open Classical
#check byContradiction
-- -- 假设 ¬p 成立，会推导出假命题 False , 那么意味着  p 成立
-- Classical.byContradiction {p : Prop} (h : ¬p → False) : p
theorem ex1 {p : Prop} (h : ¬¬p) : p :=
      byContradiction (
            -- 需要构造出 ¬p → False 这个函数
            fun hnp : ¬p => show False from (
                  -- h 作为函数，对应的参数类型恰好是 ¬p
                  h hnp
            )
      )
      -- byContradiction (fun hnp => h hnp)  -- 这是精简干净版。

/- 题 2：现在把 `dne`（双重否定消去）**当作给定的参数**发给你：
          `dne : {q : Prop} → (¬¬q → q)`（对**任意** `q` 都成立）。
          请用它证明 `p ∨ ¬p`。

    约束：⚠️ **不许用 `em` / `Classical.em` / `open Classical`**——本课要求
          「**手上只有 `dne`** 也能证出排中律」（这是原文 3.5 末尾留的练习）。

    提示：先问「**要造出目标，我得先造出哪一个 `¬¬` 的东西？**」
          （`dne` 只接受 `¬¬` 形状的输入）；再问「**那个东西要从什么出发？**」
          ⚠️ 中间有一步要用**你手上的否定假设**去造 `p ∨ ¬p`——
          **造之前先问自己造出来的是哪一边**（这是本题最容易搞反的地方），
          写完再回头检查。

    我的答案： -/
theorem ex2 (p : Prop) (dne : {q : Prop} → (¬¬q → q)) : p ∨ ¬p :=
      -- 根据 dne 可从 ¬¬(p ∨ ¬p) 推导出 p ∨ ¬p
      show p ∨ ¬p from dne (
            -- 而 dne 的参数 ¬¬(p ∨ ¬p) 等价于  ¬(p ∨ ¬p) → False
            fun h : ¬(p ∨ ¬p) => show False from h (
                  -- 而 h 的类型等价于  (p ∨ ¬p) → False ，也就是 h 作为一个函数的参数是 p ∨ ¬p ， 返回 False
                  show p ∨ ¬p from Or.intro_right p (    -- Or.inr (
                        -- 只需要构造 右侧 ¬p ， 而 ¬p 可进一步理解成  p → False
                        fun hp : p => show False from h (
                              -- 和前面类似，h 只能作用到 p ∨ ¬p ， 返回 False
                              -- 而这里构造 p ∨ ¬p 只需要构造左侧 p 即可
                              show p ∨ ¬p from Or.intro_left (¬p) hp   -- Or.inl hp
                        )
                  )
            )
      )
      -- dne (fun h => h (Or.inr (fun hp => h (Or.inl hp))))  -- 这是精简干净版。

/- 题 3：已知 `h : ¬(p ∧ q)`，证明 `¬q ∨ ¬p`。

    约束：这一题**用 `byCases` 写**（不许用 `em`）；要 `open Classical`。
          ⚠️ **注意目标里的顺序**：`¬q` 在前。

    提示：问自己「**按 `q` 分类**会得到哪两支」——
          若 `q` 成立，目标是 `¬q ∨ ¬p` 里的**哪一个**能直接拿到？
          ⚠️ 另一个分支是「`q` 不成立」，那时你能白拿的是**哪一个**？

    我的答案： -/
#check byCases
-- -- 假设 p → q 成立，并且 ¬p → q 也成立，那么 q 一定成立。
-- Classical.byCases {p q : Prop} (hpq : p → q) (hnpq : ¬p → q) : q
theorem ex3 (p q : Prop) (h : ¬(p ∧ q)) : ¬q ∨ ¬p :=
  -- 我特意按 按 `p` 分类，而不是 `q` 分类 ，这说明无论用 `p` 或 用 `q`  分类都可以证明。
  byCases (
      -- 若 p 成立，则需要先构造 ¬q 才能得到 ¬q ∨ ¬p
      fun hp : p => show ¬q ∨ ¬p from Or.inl (
            -- 构造 ¬q
            fun hq : q => show False from (
                  -- 构造 p ∧ q ，然后利用 h  获得 False
                  h ⟨hp, hq⟩
            )
      )
  ) (
      -- 若 ¬p 成立 ，则目标直接可以取右边的 ¬p 构造 ¬q ∨ ¬p
      fun hnp : ¬p => show ¬q ∨ ¬p from Or.inr hnp
  )
--   byCases (fun hp => Or.inl (fun hq => (h ⟨hp, hq⟩))) (fun hnp => Or.inr hnp) -- 这是精简干净版。


/- ============ 二、预测 / 判断 ============ -/

/- 题 4：文件顶部**没有** `open Classical` 时，`#check em p` 能不能通过？
          不能的话，是**什么错**（把关键字抄下来）。

    我的答案： 不能通过。 报错：Unknown identifier `em` -/


/- 题 5：不用 `Classical`，**能不能**自己证出 `p ∨ ¬p`（排中律）？
          给出**能 / 不能** + **一条实测依据**（哪一行代码、报什么错的关键句）。
          ⚠️ 依据要写**实测**的，不要只写「感觉不行」。

    我的答案：不能自己证出 `p ∨ ¬p`（排中律）;
    如果用 Or.elim ，无法构造第一个参数 , Application type mismatch: The argument
  p
has type
  Prop
of sort `Type` but is expected to have type
  ?m.2 ∨ ?m.3
of sort `Prop` in the application
  Or.elim p,-/

-- #check Or.elim
-- -- Or.elim {a b c : Prop} (h : a ∨ b) (left : a → c) (right : b → c) : c
-- theorem em0 (p : Prop) : p ∨ ¬p :=
--       show p ∨ ¬p from Or.elim p (by sorry) (by sorry)


/- 题 6：`byCases` 和 `byContradiction` 在本课是**什么形式**（证明项还是 tactic）？
          它们的 **tactic 版**叫什么名字、属于**第几章**？
          ⚠️ 别把 `byCases`（本课，证明项）和 `by_cases`（tactic）写混。

    我的答案：这两个都是证明项。 它们的 tactic 版分别叫 `by_cases` 和 `by_contradiction`，属于第 5 章。 -/


/- 题 7：原文说「**知道 `p` 和 `q` 不同时为真，并不能告诉你哪一个是假**」。
          据此回答两问：
          ① `theorem t (h : ¬(p ∧ q)) : ¬p ∨ ¬q` ——**需不需要** `open Classical`？
          ② `theorem t (h : ¬(p ∨ q)) : ¬p ∧ ¬q` ——**需不需要** `open Classical`？
          ⚠️ ② 那一条的**理由**要说清楚（跟 ① 的理由**不同**）。

    我的答案：前者需要 `open Classical` ，后者不需要 ，因为在 `t1` （注释中）中 的 hq 处，我始终无法写出合适的表达式 而填  hq 会报错： Unknown identifier `hq`Lean 4(lean.unknownIdentifier)，而 `t2` 可以证明 -/

-- theorem t1 {p q : Prop} (h : ¬(p ∧ q)) : ¬p ∨ ¬q :=
--       show ¬p ∨ ¬q from (
--             Or.inl (fun hp => show False from (h ⟨hp, hq⟩))
--       )

theorem t2 {p q : Prop} (h : ¬(p ∨ q)) : ¬p ∧ ¬q :=
      show ¬p ∧ ¬q from (
            ⟨
                  (fun hp : p => show False from h (Or.inl hp)),
                  (fun hq : q => show False from h (Or.inr hq))
            ⟩
      )

/- 题 8：三种「二选一」的写法 —— `Or.elim (em p) …`、`byCases …`、`byContradiction …` ——
          各自**要你写几支**？为什么 `byContradiction` 少一支？
          ⚠️ 回答时请**分别写清每一支写的是什么**，不要笼统说「都是分类讨论」。

    我的答案：第一个 `Or.elim (em p) …` 要写两支，`byCases …` 也要写两支，`byContradiction …` 只写一支，因为它直接假设结论的否定，少了一次分类讨论。 -/


-- ============ 验证区（先自己判断，判完再**取消注释**核对）============
--
-- ⚠️ 这里故意留成注释：否则你一跑检查脚本，结果就直接印出来了。
-- ⚠️ 本区**只给你自己核对用**，里面**不写任何预期结果**。
--
-- ⚠️ 讲义 §2、§3 里那些**故意写错**的写法在**讲义/示例里**（不参与本文件的检查）。

variable (p q : Prop)

-- 题 4 的实验（自己跑一遍）：
-- #check em p  如果没有 open Classical，会报错。 但是这里取消注释看不出来，因为 前面执行过了 open Classical
-- open Classical
#check em p

-- 题 5 的实验（**第一段会报错**，故意的）：
-- theorem em0 (p : Prop) : p ∨ ¬p :=
--   Or.elim p (fun hp => Or.inl hp) (fun hnp => Or.inr hnp)

-- 题 7 的两问（自己跑一遍；⚠️ ① 那段**要** open，② 那段**不要**）：
-- ① 需要 open：
open Classical
variable (p q : Prop)
theorem both1 (h : ¬(p ∧ q)) : ¬p ∨ ¬q :=
  Or.elim (em p)
    (fun hp : p => Or.inr (show ¬q from fun hq => h ⟨hp, hq⟩))
    (fun hp : ¬p => Or.inl hp)

-- -- ② **不**需要 open（想验证就把它**单独**放一个文件里跑）：
theorem both2 (h : ¬(p ∨ q)) : ¬p ∧ ¬q :=
  ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩

-- 题 6 的 tactic 版**名字**（第 5 章内容，这里只记名字，不展开）：
-- `by_cases h1 : p`  /  `by_contradiction h`
