# AGENTS.md — Lean4Practice

> 本文件是本项目的**长期记忆与协作契约**。
> 目的：即使历史会话被删除、或换到全新会话/新模型，只要读本文件，就能按同样的方式接续开发，不必重新摸索，也不该重复犯同样的错误。
> **本文件由 AI 助手在恰当时机主动维护**（见 §9），用户只负责交流与拍板。

---

## 1. 项目概述与当前状态

**Lean4Practice** 是一个 Lean 4 学习与实践项目。

**当前状态（截至 2026-09-17）**：

- 已是 **git 仓库**（分支 `main`），远程 `origin` = `git@github.com:chaoskey/Lean4Practice.git`（SSH），**已推送成功**。
- GitHub 仓库为 **PUBLIC**：<https://github.com/chaoskey/Lean4Practice>（默认分支 `main`）。
- **已建立最小可编译基线**：Lean `v4.34.0` 已安装，`lake build` **通过**（见 D7）。
- **有意不引入 mathlib**（原因见 D2/D7；需要时再定）。
- 项目定位**有意先不定死**（用户决策）：边学边定，本文件随进展演化。
- 已固化的内容：**环境事实**（§2）、**关键决策**（§3）、**协作约定**（§5、§8、§9）；Lean 内容层面的约定仍待形成（见 §7）。

> ⚠️ 给接续者的第一条指令：**不要凭想象补全本项目的内容约定**。若本文件某处仍标为「待形成」，说明它尚未确定；请先与用户确认，再把结论写进 §7。

---

## 2. 环境事实（已实测验证，勿重新摸索）

| 项 | 事实 |
|---|---|
| 系统 | WSL2 + Ubuntu 22.04.5 LTS（kernel `6.6.87.2-microsoft-standard-WSL2`） |
| 项目路径 | `/mnt/e/DSHSpace/Lean4Practice`（Windows `E:\DSHSpace\Lean4Practice`） |
| 挂载类型 | `9p`/drvfs：`E:\ on /mnt/e type 9p (rw,noatime,...,msize=65536,...)` |
| 大小写 | **不敏感**（Windows 语义）——实测 `.casetest_ABC` 与 `.casetest_abc` 视为同一文件 |
| 权限位 | **无效**——实测 `chmod 700` 后 `stat` 仍为 `777` |
| 符号链接 | **可用**——实测在 `/mnt/e` 下创建指向 Linux 家目录的符号链接，可创建且可正常读取 |
| CPU / 内存 | **2 核 / 3.8 GiB**（实测可用约 2.2 GiB，空闲常常只有几百 MiB） |
| 磁盘 | Linux 根 `/` 可用约 880 G；`/mnt/e` 可用约 363 G |
| Lean 工具链 | **已安装**：`leanprover/lean4:v4.34.0`，位于 `~/.elan/toolchains/leanprover--lean4---v4.34.0`；`lean`/`lake` 是 elan 的代理可执行文件 |
| elan | `4.2.4`，装于 `~/.elan`（Linux 侧，符合 D1） |
| PATH | ⚠️ elan 只把 `~/.elan/bin` 写进 `~/.profile`，**非登录 shell 不加载** → 见 §6.6 |
| 网络代理 | **可用**：宿主机 WSL2 网关 + 端口 **10808**，用于网络不稳时兜底 → 用法与实测结论见 §6.14 |
| git | `2.34.1`；`user.name=chaoskey`，`user.email=joistwang@sina.com`；本仓库已设 `core.autocrlf=false` |
| GitHub 认证 | **SSH 可用**（`ssh -T git@github.com` 认证为 `chaoskey`）；`gh` CLI 2.92.0 **已登录**，scopes `gist, read:org, repo`，`git_protocol=ssh` |
| gh token 位置 | **明文**存于 `~/.config/gh/hosts.yml`（`gh auth login` 已警告）。属敏感文件，不要提交、不要外传、不要贴进日志 |
| 换行符 | 由 `.gitattributes` 统一托管为 **LF**（见 D4） |

**工具链已就绪，`lake build` 实测通过**（见 D7）。若 `lake` 报 command not found，那是 PATH 问题而非未安装（§6.6）。

---

## 3. 关键决策记录（ADR 风格）

### D1. 源码放 `/mnt/e`，构建缓存与工具链放 Linux 侧 ✅已定并实测验证

- **背景**：`/mnt/e` 是 9p 网络式挂载，读写慢；且**权限位无效、大小写不敏感**。Lean 工具链二进制依赖可执行权限位，`.lake` 构建产物量大且读写频繁。
- **决策**：项目源码留在 `/mnt/e`（便于 Windows 侧直接查看/编辑）；**elan 工具链装到 `~/.elan`（Linux 侧）**；**`.lake` 构建缓存通过符号链接落到 Linux 侧**。
- **依据**：符号链接可用性已实测（§2）。目标目录示例：`~/.lean4-build/Lean4Practice/.lake`。
- **预期做法**（工具链装好后执行）：
  ```bash
  mkdir -p ~/.lean4-build/Lean4Practice
  ln -s ~/.lean4-build/Lean4Practice/.lake /mnt/e/DSHSpace/Lean4Practice/.lake
  ```
- **✅ 验证结果（2026-09-17 实测）**：`.lake` 已建为符号链接 → `~/.lean4-build/Lean4Practice/.lake`。oleans 实体经 `df` 确认落在 **Linux 根文件系统**（挂载点 `/`）；经符号链接读写正常；`git status` 中 `.lake` 被正确忽略。**该决策成立，勿再怀疑。**
- **约束**：`.lake` 已写入 `.gitignore`，不得提交。

### D2. 不运行无缓存的全量构建 ⚠️硬约束

本机仅 **2 核 / 3.8 GiB 内存**。**从源码构建 mathlib 在本机基本不可行**（内存与核数都不够，且可能拖垮 WSL）。

- 需要 mathlib 时，**必须优先使用预编译缓存**（如 `lake exe cache get`），不要 `lake build` 整个 mathlib。
- 大构建前提示用户关闭其他占用内存的程序；同一时间避免并行跑多个重构建。
- 若某任务确需全量构建，**先向用户说明代价并取得同意**，不要闷头开跑。

### D3. 项目定位边学边定 ✅已定

不预先假设「跟教材 / 形式化 / 建库」中的某一条；实际形态由进展决定，并**及时回写本文件**。

### D4. 版本控制：分支 `main`，SSH 远程，换行符由 `.gitattributes` 托管 ✅已定

- **背景**：`core.autocrlf` 未设置，项目又位于 Windows/WSL 共享盘，双向编辑极易改动换行符、污染 diff（原 §6.5 风险）。
- **决策**：仓库默认分支为 `main`；仓库内设 `core.autocrlf=false`；**提交 `.gitattributes`，把文本文件显式固定为 LF**，二进制类型显式标记为 `binary`。
- **远程**：`origin` 走 SSH（`git@github.com:chaoskey/Lean4Practice.git`），不用 HTTPS，避免推送环节 token 落盘。
- **仓库可见性**：现为 **PUBLIC**。创建时曾是 PRIVATE，**用户于 2026-09-17 主动改为公开，并确认属有意为之**。改回私有的命令（如需）：
  ```bash
  gh repo edit chaoskey/Lean4Practice --visibility private
  ```
- **⚠️ 仓库已公开：不得写入敏感信息**。本文件记录了本机环境细节（路径、内存、WSL 网关形态、`gh` token 的**存放位置**等）——这些属于可公开的一般性信息，但**今后严禁向仓库加入任何凭据、token、私钥、内网地址、他人隐私**。**不确定某内容是否适合公开时，先问用户，不要先提交再问。**
- **兄弟项目对比**：`Modclasphys`/`Physym`/`Undle` **都没有配置任何 GitHub remote**（纯本地仓库），也**没有任何 GitHub 相关文档约定**；它们只贡献了「提交信息用中文」这一条风格惯例。`.gitattributes` 亦为三仓库所无，本项目**有意先行一步**。

### D5. `README.md` 显著声明「本项目完全由 AI 开发」 ✅已定

- **来源**：用户明确要求——除常规项目说明外，**特意强调这是一个完全的 AI 项目**。
- **决策**：`README.md` 顶部以「徽章 + 引用块横幅」双重强调，并单设章节「『完全由 AI 开发』意味着什么」，写明分工：**人类只提需求与拍板；AI 负责全部撰写、提交、推送与自我维护**。
- **必须保留的诚实条款**：README 中明确写出「AI 输出可能出错，『AI 说已验证』不等于真的验证过」。这是该声明可信度的基础，**不要为了让项目看起来更可靠而删掉这一段**。
- **无先例**：`Modclasphys`/`Physym`/`Undle` **都没有 README**，本项为**新立惯例**。
- **语言**：中文（遵循 §5.1）。
- **遗留**：无（`LICENSE` 已于 D6 确定为 MIT）。

### D6. 采用 MIT 许可证 ✅已定

- **来源**：用户明确指定「采用 MIT 许可」。
- **决策**：仓库根目录放**标准 MIT 全文** `LICENSE`，`Copyright (c) 2026 chaoskey`。
- **版权主体**：归 **GitHub 账号 `chaoskey`**（自然人）。本项目内容虽全部由 AI 生成，但**在多数司法辖区 AI 不能成为著作权主体**，故权利归创建并维护仓库的人。该主体是用户未指定时由助手按惯例选定的默认值；**若要改成真实姓名或邮箱，只需修改 `LICENSE` 第 3 行**。
- **无先例**：`Modclasphys`/`Physym`/`Undle` **均无 LICENSE**，本项为新立惯例。
- **README**：已加 MIT 徽章并改写「许可」章节，同时说明版权归属；该徽章 URL 为纯 ASCII，无需百分号编码（对比 §6.12）。
- **⚠️ 不要改动许可证措辞**：`LICENSE` 是法律文本，**不要翻译、改写或增删**；如需更换许可证，应整体替换为标准全文。

### D7. 最小可编译基线已建立（Lean v4.34.0，不含 mathlib） ✅已定并已验证

- **来源**：用户选择「先建立最小可编译基线」，而不是直接引入 mathlib、也不是先定方向。
- **决策**：工具链固定 **`leanprover/lean4:v4.34.0`**（写入 `lean-toolchain`）；**暂不引入 mathlib**——本机内存吃紧（D2），需要时再定，改 `lean-toolchain` 一行即可。
- **项目骨架**：`lakefile.toml`（包名 `lean4practice`，库名 `Lean4Practice`）+ 库根模块 `Lean4Practice.lean` + `Lean4Practice/Basic.lean`（冒烟测试）。
- **实测数据**：首次 `lake build` **25 秒**通过；增量构建 **0 秒**；`.lake` 体积约 **100 K**（纯核心、无依赖）。
- **验证强度（重要）**：除「构建成功」外还做了**反向测试**——故意加入错误证明 `(1 : Nat) = 2 := rfl`，确认构建**确实失败**并报出类型错误，随后还原并重新构建成功。这排除了「构建假成功」，说明工具链真的在做类型检查。
- **⚠️ 骨架是临时的**：库名与目录结构是为跑通链路而设，**主线形态定下后可能调整**（见 §7）。

---

## 4. 目录结构与现状

截至 2026-09-17，仓库内**实际存在**的文件（当前状态：**可编译通过**）：

```
Lean4Practice/
├── README.md            # 对外说明；显著声明本项目为「完全由 AI 开发」（D5）
├── LICENSE              # MIT 许可证全文（D6）
├── AGENTS.md            # 本文件（长期记忆与协作契约）
├── lean-toolchain       # 固定 Lean 版本：leanprover/lean4:v4.34.0（D7）
├── lakefile.toml        # Lake 项目定义（包名 lean4practice，库名 Lean4Practice）
├── lake-manifest.json   # 依赖锁定（当前无依赖）；由 lake 生成，**应提交**
├── Lean4Practice.lean   # 库根模块，负责 import 各子模块
├── Lean4Practice/       # 源码目录（目录名须与库名一致）
│   └── Basic.lean       # 冒烟测试：几个 trivial 证明
├── .gitignore           # 忽略 .lake / 构建产物 / 编辑器杂项
├── .gitattributes       # 换行符与文本/二进制属性托管（D4）
├── .lake -> ~/.lean4-build/Lean4Practice/.lake   # 符号链接，本机专属，已被忽略
└── .git/                # 本地仓库
```

尚未确定、留待主线形态定下后再定（见 §7）：

- 练习 / 形式化内容的目录组织（按章节？按主题？）
- 是否引入 mathlib 及其版本

> 注：`lakefile.toml` 与 `lakefile.lean` **不要同时存在**。
> 注：**新增 `.lean` 文件后，必须在 `Lean4Practice.lean` 里加上对应 `import`**，否则 `lake build` 不会编译它（这是 Lean 与多数语言不同的地方）。
> 注：`.lake` 是**符号链接**，只在本机成立，必须保持被忽略。

---

## 5. 沿用兄弟项目的既有约定（跨项目惯例）

本用户在同一父目录 `/mnt/e/DSHSpace/` 下已有多个项目（`Modclasphys`、`Physym`、`Undle`），其 `AGENTS.md` 是本项目的**惯例来源**。已沿用的约定：

1. **沟通与文档语言**：与用户交流、以及项目文档，一律使用**简体中文**。
2. **提交信息用中文**：这三个仓库的提交信息均为中文，短的如「完善 Agents.md」，长的直接是一句话任务描述。
3. **`AGENTS.md` 是唯一约定入口**：新会话先读本文件，再动手。
4. **文件编码统一 UTF-8**。
5. **不修改原始/权威资料**：只读输入（原始 PDF、参考基线）永不就地改动。
6. **工作产物与最终交付物分离**：兄弟项目用 `work/` 放脚本与中间产物；本项目如需，沿用同名目录。
7. **进展可续**：长流程需有「进度」记录（兄弟项目 `workflow.md` + `videos/第N课/进度.md` 的 Runbook 模式，标注 🔧自动 / 👤人工）。本项目若出现长流程，沿用该模式。

---

## 6. 踩坑与风险清单（本机实测结论）

按「避免重复踩坑」的目标，**每条都给出可执行的对策**。

1. **大小写不敏感**：`Foo.lean` 与 `foo.lean` 会互相覆盖，模块名不能只靠大小写区分。写文件前先确认命名唯一（忽略大小写）。
2. **权限位无效（恒为 777）**：任何依赖 `chmod +x` 的流程（工具链、脚本）**不要放在 `/mnt/e`**；放 Linux 侧。
3. **9p 挂载慢**：大批小文件读写（构建产物、依赖下载）**必须放 Linux 侧**；不要把 `.lake` 留在 `/mnt/e`。
4. **内存极小**：见 D2。警惕 OOM；重任务前后用 `free -h` 确认余量。
5. **换行符**：本仓库已用 `.gitattributes` 固定为 LF（D4），**该文件不要删**；新加文本类型时记得补进 `.gitattributes`。
6. **`lake`/`lean` 不在 PATH 里**（极易被误判成「工具链没装」）：elan 只把 `~/.elan/bin` 写进 `~/.profile`，而 **本 harness 的每条命令都是非登录、非交互 shell，不会加载 `~/.profile`**，直接调 `lake` 必报 command not found。**每条涉及 Lean 的命令都要先加**：
   ```bash
   export PATH="$HOME/.elan/bin:$PATH"
   ```
   工具链本身**已装好**（§2/D7），不要因这个报错去重装。
7. **符号链接需谨慎提交**：`.lake` 之类的链接只在本机成立，**必须保持被 gitignore**，否则会把本机绝对路径泄漏进仓库。
8. **本项目在 `E:` 盘**：Windows 侧程序可能同时在编辑同一批文件；改动前留意非 WSL 来源的变更，避免互相覆盖。
9. **`/mnt/e` 上 `git` 较慢**：9p 下 `git status`/`add` 大仓库时明显变慢；保持仓库精简，不要把构建产物纳入版本控制。
10. **仓库可见性会改变 API 行为（易误判）**：本仓库**已公开**，匿名 `curl https://api.github.com/repos/chaoskey/Lean4Practice` 现在返回 **200**；而**私有**时同一请求返回 **404**——与「仓库不存在」**完全无法区分**，曾导致误判成「没建成功」。**判断可见性/存在性要用已登录的 `gh`，不要靠匿名请求猜**：
    ```bash
    gh repo view chaoskey/Lean4Practice --json visibility,isPrivate,url
    ```
11. **SSH 无法创建仓库**：GitHub 不支持 push-to-create；远端仓库必须先由网页或 API 创建一次，之后推送才能全走 SSH。不要反复重试 `git push` 试图「创建」仓库。
12. **shields.io 徽章里的非 ASCII 必须百分号编码**：`README.md` 顶部徽章中，直接把中文写进 URL（如 `.../badge/status-早期搭建中-orange`）会返回 **HTTP 400**，页面上显示为**破图**。必须用百分号编码，例如：
    ```
    https://img.shields.io/badge/status-%E6%97%A9%E6%9C%9F%E6%90%AD%E5%BB%BA%E4%B8%AD-orange
    ```
    生成方式：`python3 -c "import urllib.parse;print(urllib.parse.quote('早期搭建中',safe=''))"`。
    **改动徽章后要用 `curl -o /dev/null -w '%{http_code}'` 确认返回 200**，不要凭肉眼判断。
13. **Lake 要求库根模块文件存在**：`lean_lib` 名为 `Foo` 时，Lake 要求存在 **`Foo.lean`**（根模块）；**只有 `Foo/` 目录没有根文件会直接报错** `no such file or directory ... Foo.lean`。新增源码的完整流程是：写 `Lean4Practice/Xxx.lean` → 在 `Lean4Practice.lean` 中 `import Lean4Practice.Xxx`。
14. **网络不稳定，下载必须重试**：本机访问 GitHub 实测会间歇失败——`curl: (16) Error in the HTTP2 framing layer`、`(28) Failed to connect ... timed out`、`(56) SSL_read: unexpected eof`。elan 安装包实测**第 3 次尝试**才成功。**不要把单次失败当成「资源不可用」而放弃或改方案。**
    **兜底顺序**：① 直连 + 重试（并加 `--http1.1`）→ ② 仍失败则挂**宿主机代理**。

    **宿主机代理用法（用户提供，2026-09-17 实测可用）**：
    ```bash
    host_ip=$(ip route show default | awk '{print $3}')   # WSL2 网关 = Windows 宿主机
    export http_proxy="http://$host_ip:10808"
    export https_proxy="http://$host_ip:10808"
    ```
    - 代理端口固定 **10808**；实测 `http://` 与 `socks5h://` 均可用（`curl -x` 形式）。
    - **必须用环境变量形式，不要只用 `curl -x`**：`elan` / `lake` 等自带的下载器**不认命令行 `-x` 参数，只读 `http_proxy`/`https_proxy` 环境变量**（实测环境变量方式 HTTP 200 通过）。
    - ⚠️ **IP 必须动态获取，不要写死**：实测解析结果为 `172.27.16.1`，但 WSL 重启后网关地址可能变化。
    - 实测 GitHub release 下载经代理与直连**字节一致**（`cmp` 通过），代理不污染内容。
    - **对 SSH 无影响**：`origin` 走 SSH，而 SSH 不读 `http_proxy`；GitHub 的 SSH 直连正常，无需为 SSH 配代理。
    - 实测直连当前也可用（HTTP 200、约 0.4 秒）；代理是**不稳定时的兜底**，不是默认路径。

---

## 7. 待形成的约定（占位，请勿凭空填充）

以下内容**尚未确定**，待实际实践中形成后再回写；形成前请勿在代码或文档里当作既定规则：

- [ ] 本项目的主线形态（跟教材习题 / 数学形式化 / 自建库）与对应的目录组织（**当前骨架见 §4/D7，属临时**）
- [x] ~~Lean 工具链版本~~ → **已固定 `leanprover/lean4:v4.34.0`**，见 D7（mathlib 暂不引入，需要时再定）
- [ ] 命名约定：文件/模块/定理命名风格（`snake_case`、`UpperCamelCase`、命名空间划分）
- [ ] 证明风格：是否偏好 `calc`/`linarith`/`simp` 等 tactic 的取舍，及 `sorry` 的使用边界
- [ ] 是否保留 `#check`/`#eval` 等调试痕迹；注释与文档字符串规范
- [ ] 提交粒度与提交信息格式（当前约定见 §8）
- [ ] 是否创建 `CLAUDE.md -> AGENTS.md` 符号链接（参考实现仓库的做法）
- [x] ~~是否补充 `README.md`~~ → **已完成**，见 D5
- [x] ~~是否选定 `LICENSE`~~ → **已定为 MIT**，见 D6

---

## 8. 工作方式约定

- **动手前**：阅读本文件；若涉及 `§7` 未定项，先问用户，不要自行拍板成「约定」。
- **改动后**：能验证的必须验证（编译/运行/测试），并在回复中说明验证方式与结果；**不要声称已验证而实际未验证**。
- **不确定就说不确定**：区分「已实测事实」「推测」「待确认」，不要把推测写成事实。
- **不擅自扩大范围**：用户说只做 A，就不要顺手改 B；发现别的问题，提出来，不擅自改。
- **失败要暴露**：命令失败要报告退出码与关键输出，不要掩盖或绕过。
- **提交信息**：中文，首行简短概括，必要时正文说明「为什么」；一次提交聚焦一件事。
- **推送**：走 SSH 远程 `origin`。推送前先 `git status` 确认没有误提交构建产物或本机路径。
- **远程操作**：`gh` 已登录且 `git_protocol=ssh`。创建仓库用 `gh repo create`（SSH 本身不能创建仓库，见 §6.11）；查询状态优先用 `gh` 而非匿名 `curl`（见 §6.10）。

---

## 9. 本文件的维护协议（AI 助手职责）

**由 AI 助手主动维护**，用户不必提醒。满足以下任一触发条件即更新本文件：

1. 形成了新的**重复性工作流**或稳定做法（→ 写进对应章节）。
2. 用户**纠正**了助手的做法或偏好（→ 立即固化，避免重犯）。
3. **踩到新坑并解决**（→ 追加到 §6，附对策）。
4. **环境或工具链发生变化**（→ 更新 §2）。
5. 做出了**影响后续的决策**（→ 追加到 §3）。
6. `§7` 中某项**从待定变为确定**（→ 移出占位，写成正式约定，勾掉条目）。
7. 发现本文件**内容已过时或与事实不符**（→ 修正，而不是绕过）。

**维护规则**：

- 每次更新同步在 §10 追加一行变更记录。
- 保持「已验证事实 / 推测 / 待确认」的区分，**不写入未经确认的推测**。
- 优先**增量修订**，保持结构稳定；大改需向用户说明理由。
- 本文件应保持可读、可执行：多用具体命令、路径、对策，少用空泛表述。

---

## 10. 变更记录

| 日期 | 版本 | 变更 | 说明 |
|---|---|---|---|
| 2026-09-17 | v0.1 | 创建初始版本 | 固化环境事实（§2）、三项关键决策（§3）、跨项目惯例（§5）、实测踩坑清单（§6）与维护协议（§9）；Lean 内容约定留待形成（§7） |
| 2026-09-17 | v0.2 | 建立 git 仓库 | 新增 D4（`main` 分支 + `.gitattributes` 托管 LF）；新增 `.gitignore`；§6.5 换行符风险标记为已缓解、新增 §6.9；§4 改为记录实际文件；§8 补充提交与推送约定 |
| 2026-09-17 | v0.3 | 推送 GitHub 并记录认证事实 | §2 更新 `gh` 登录状态与 token 明文位置；D4 补充「仓库为 PRIVATE」及切换命令、并澄清兄弟项目无任何 GitHub remote；§5 补充「提交信息用中文」；新增 §6.10（私有仓库 API 返回 404 的误判）与 §6.11（SSH 不能创建仓库）；§8 补充远程操作约定 |
| 2026-09-17 | v0.4 | 新增 README.md（D5） | 按用户要求创建 `README.md`，以徽章 + 横幅 + 独立章节强调「本项目完全由 AI 开发」，并写入「AI 输出可能出错」的诚实条款；§7 勾掉 README 项、`LICENSE` 仍待定；§4 更新实际文件清单 |
| 2026-09-17 | v0.5 | 修复 README 徽章并记录该坑 | README 中两个含中文的 shields.io 徽章实测返回 HTTP 400（显示为破图），改为百分号编码并验证返回 200；新增 §6.12 记录该坑与「必须用 curl 验证徽章」的要求 |
| 2026-09-17 | v0.6 | 确定 MIT 许可证（D6） | 新增标准 MIT 全文 `LICENSE`（`Copyright (c) 2026 chaoskey`）；D5 遗留清零；README 加 MIT 徽章、改写「许可」章节并说明版权归属（AI 不能成为著作权主体）；§7 勾掉 LICENSE 项；§4 更新文件清单 |
| 2026-09-17 | v0.7 | 建立最小可编译基线（D7） | 安装 elan `4.2.4` + Lean `v4.34.0`；建立 lake 项目（`lakefile.toml` / `Lean4Practice.lean` / `Lean4Practice/Basic.lean`）；`.lake` 符号链接**实测成立**（D1 由计划变为已验证）；`lake build` 25 秒通过并做反向测试确认真的在做类型检查；§2 更新工具链事实；§6.6 由「工具链缺失」改写为 **PATH 陷阱**，新增 §6.13（Lake 根模块）、§6.14（网络不稳需重试）；§4 更新为实际可编译清单；§7 勾掉工具链版本项 |
| 2026-09-17 | v0.8 | 记录宿主机代理用法（用户提供） | 用户给出 WSL 代理方案（`host_ip=$(ip route show default \| awk '{print $3}')`，端口 `10808`）。已**实测验证**并写入 §6.14：`http`/`socks5h` 均可、环境变量形式生效（elan/lake 只读环境变量不认 `curl -x`）、release 下载经代理与直连字节一致、SSH 不受影响；§2 新增代理行 |
| 2026-09-17 | v0.9 | 仓库改为 PUBLIC，同步文档并加公开约束 | 发现仓库已由 PRIVATE 变为 **PUBLIC**（用户确认属有意为之；助手未执行任何改可见性的命令）。同步 §1 与 D4；**D4 新增硬约束**：仓库公开后严禁写入凭据/私钥/内网地址等敏感信息，不确定先问用户；§6.10 改写为「可见性会改变 API 行为」——公开返回 200、私有返回 404，判断要用 `gh` 而非匿名请求 |
