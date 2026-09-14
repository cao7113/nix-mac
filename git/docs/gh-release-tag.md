# git tag & gh release

在 GitHub 的设计体系中，**Tag（标签）** 和 **Release（发布版本）** 是两个既有紧密联系又处于不同层面的概念：

* **Git Tag**：属于标准 Git 的底层机制。它本质上只是指向特定 Commit 的指针（类似于不可变的 Branch），由 Git 本身维护。
* **GitHub Release**：属于 GitHub 平台扩展的业务对象。它必须建立在特定的 **Git Tag** 之上，添加了像 Release Notes、二进制产物附件（Assets）、草稿状态（Draft）以及预发布（Pre-release）标识等 GitHub 特有功能。

`gh` 作为 GitHub CLI 工具，对 Tag 的所有操作都是围绕 **Release 的生命周期** 展开的。

---

### 1. Tag 与 Release 的对应关系

* **1 对 1 / 1 对 0 绑定**：每一个 GitHub Release **必须关联且仅能关联一个** Git Tag；但仓库里的 Git Tag 不一定都有对应的 Release。
* **延迟/自动创建 Tag**：当你使用 `gh release create` 指定一个不存在的 Tag 时，GitHub 会在服务端根据你指定的 Commit（默认是主分支最新 Commit）**自动帮你创建对应的 Git Tag**。

---

### 2. 核心操作与 Tag 的互动逻辑

#### A. 创建 Release（创建/关联 Tag）

```bash
# 1. 基础创建：如果 v1.0.0 Tag 存在则直接绑定；若不存在，GitHub 会在默认分支自动创建该 Tag
gh release create v1.0.0 --title "v1.0.0" --notes "初始发布"

# 2. 明确指定基于某个分支或 Commit 哈希创建 Tag 并发布
gh release create v1.0.0 --target main --title "v1.0.0" --notes "基于 main 分支创建"
gh release create v1.0.0 --target 8f3a12b --title "v1.0.0" --notes "基于指定 Commit 创建"

# 3. 自动生成 Release Notes（推荐）
# GitHub 会根据上一个 Tag 到当前 Tag 之间的 PR 自动生成变更日志
gh release create v1.0.0 --generate-notes

```

#### B. 删除 Release 与 Tag 清理

在删除 Release 时，默认情况下 **Git Tag 仍会留在远程仓库中**。如果需要同步删除远程 Tag，必须显式加上 `--cleanup-tag` 参数：

```bash
# 仅删除 GitHub 上的 Release 包装，远程 Git Tag 依然保留
gh release delete v1.0.0

# 同时删除 GitHub Release 和远程 Git Tag
gh release delete v1.0.0 --cleanup-tag

```

> **注意**：`--cleanup-tag` 只会删除 **GitHub 远程仓库** 上的 Tag。如果本地已经 `git pull` 过该 Tag，还需要手动运行 `git tag -d v1.0.0` 清理本地指针。

#### C. 查询与读取 Tag 关联数据

```bash
# 查看特定 Tag 对应 Release 的详细内容（包括关联的资产文件、说明和状态）
gh release view v1.0.0

# 在浏览器中直接打开该 Tag 的 Release 页面
gh release view v1.0.0 --web

```

---

### 3. 工作流总结（典型使用场景）

典型的发布流程通常有两种路径：

1. **先本地打 Tag 推动，再创建 Release**：
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
gh release create v1.0.0 --generate-notes

```


2. **完全委托 `gh` 托管（一步到位）**：
```bash
# 无需事先运行 git tag，直接一条命令搞定 Tag 和 Release
gh release create v1.0.0 --generate-notes ./dist/*

```