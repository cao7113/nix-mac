# Git tag

用 **CRUD（创建 Create、读取 Read、更新 Update、删除 Delete）** 模型来梳理 `git tag`，可以非常直观地建立起完整的知识体系。

Git Tag（标签）本质上是**指向某个特定 Commit 的只读指针（或不可变快照）**。它通常用来标记版本发布点（如 `v1.0.0`）。

---

### 一、 CRUD 全景对比概览

| 操作 | 本地操作 (Local Git) | 远程同步 (Remote GitHub/GitLab) |
| --- | --- | --- |
| **C (Create)** | `git tag <tag_name>` *(轻量标签)*<br>

<br>`git tag -a <tag_name> -m "msg"` *(附注标签)* | `git push origin <tag_name>`<br>

<br>`git push origin --tags` |
| **R (Read)** | `git tag` *(列表)*<br>

<br>`git show <tag_name>` *(详情)* | `git ls-remote --tags origin`<br>

<br>`gh release list` |
| **U (Update)** | `git tag -f <tag_name> [commit_id]` *(强制覆盖本地)* | `git push origin -f <tag_name>` *(强制覆盖远程)* |
| **D (Delete)** | `git tag -d <tag_name>` | `git push origin --delete <tag_name>`<br>

<br>`gh release delete <tag_name> --cleanup-tag` |

---

### 二、 细化解析与进阶应用

#### 1. Create (创建)

Git 中的 Tag 分为两类：**轻量标签 (Lightweight Tag)** 和 **附注标签 (Annotated Tag)**。生产环境强力推荐使用**附注标签**。

* **轻量标签 (Lightweight)**：仅仅是一个指向特定 Commit 的快捷引用/指针，不包含创建者、时间或说明信息。
```bash
# 基于当前分支最新的 Commit 创建
git tag v1.0.0-light

# 基于历史某个 Commit 创建
git tag v0.9.0 9fceb02

```


* **附注标签 (Annotated)**：在 Git 数据库中存储为一个独立的完整对象，包含**打标签者的姓名、Email、日期、签名以及日志信息**。
```bash
# 创建带注释的附注标签
git tag -a v1.0.0 -m "Release version 1.0.0: stable feature release"

# 为历史 Commit 补打附注标签
git tag -a v0.9.0 9fceb02 -m "Archive version 0.9.0"

```


* **推送至远程**：
默认情况下，`git push` **不会**自动将本地 Tag 推送到远程服务器，必须显式推送：
```bash
# 推送单个指定 Tag
git push origin v1.0.0

# 一次性推送本地所有尚未推送的 Tag
git push origin --tags

```



---

#### 2. Read (读取 / 查询)

* **本地查询**：
```bash
# 列出所有本地 Tag（按字母排序）
git tag

# 结合通配符模糊搜索 Tag（例如只看 v1.x 系列）
git tag -l "v1.*"

# 查看指定 Tag 的详细元数据（签名者、打标签时间、绑定的 Commit 及 Commit 提交信息）
git show v1.0.0

# 查看包含特定 Commit 的 Tag（排查某个 Bug 在哪个版本包含）
git tag --contains <commit_hash>

```


* **远程查询**：
```bash
# 不拉取代码，直接查看远程仓库有哪些 Tag
git ls-remote --tags origin

# 配合 GitHub CLI 查看 GitHub 上的 Release / Tag 绑定的版本信息
gh release list

```



---

#### 3. Update (更新 / 重新指向)

> ⚠️ **规范建议**：根据语义化版本（SemVer）规范，Tag 一旦发布（特别是已推送到远程）原则上是**不可变（Immutable）**的。如果代码有修补，应该发布新的小版本号（如 `v1.0.1`）。但如果操作失误打错位置，可以使用强制覆盖模式。

* **更新本地 Tag**：
```bash
# 使用 -f (--force) 选项强制将已有 Tag 重新指向到当前的 HEAD 或指定的 Commit
git tag -f v1.0.0 <new_commit_hash> -m "Corrected version 1.0.0 tag location"

```


* **更新远程 Tag**：
更新完本地后，需要强制推送到远程覆盖：
```bash
git push origin -f v1.0.0

```



---

#### 4. Delete (删除)

* **删除本地 Tag**：
```bash
# 删除单个本地 Tag
git tag -d v1.0.0

```


* **删除远程 Tag**：
删除本地 Tag 并不会影响远程仓库，必须手动删除远程引用：
```bash
# 方法 A：使用标准 Git 语法删除远程 Tag
git push origin --delete v1.0.0

# 方法 B：推送空引用到远程 Tag（旧版本 Git 常用）
git push origin :refs/tags/v1.0.0

# 方法 C：使用 GH CLI 同步清理 GitHub Release 与远程 Tag
gh release delete v1.0.0 --cleanup-tag

```



---

### 三、 底层原理与目录结构 (Git Internal)

为了更深入地透视 Git Tag 的本质，可以观察 `.git/` 隐藏目录下的存储变化：

1. **轻量标签存储**：
位于 `.git/refs/tags/v1.0.0`，文件内容**仅包含 40 位的 Commit SHA-1 哈希值**。
2. **附注标签存储**：
* `.git/refs/tags/v1.0.0` 中存储的是一个**新 Tag 对象的 SHA-1 哈希值**。
* 该对象保存在 `.git/objects/` 中，可以通过 `git cat-file -p v1.0.0` 读取，内容结构如下：
```text
object 8f3a12b... (绑定的 Commit 哈希)
type commit
tag v1.0.0
tagger Author Name <author@example.com> 1700000000 +0800

Release version 1.0.0 log content

```