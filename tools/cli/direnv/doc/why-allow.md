# How allow works?

在 macOS 上，当你运行 `direnv allow` 时，授权记录并不会直接写在你的项目目录下，而是存储在一个全局的“信任数据库”中。

具体位置如下：

### 1. 存储路径

默认情况下，`direnv` 遵循 XDG 规范，授权数据存放在：

> **`~/.local/share/direnv/allow`**

如果你在终端里直接跳转，可以运行：

```bash
cd ~/.local/share/direnv/allow

```

### 2. 存储格式

在这个目录下，你会看到一堆以**长哈希值**命名的文件。

- **文件名**：是对 `.envrc` 文件完整路径的哈希处理。
- **文件内容**：是该 `.envrc` 文件的**绝对路径**。

### 3. 工作原理（为什么这样设计？）

`direnv` 之所以不把“已允许”的状态写在项目里的 `.envrc` 中，主要有两个原因：

1. **安全性**：防止你下载了一个恶意的项目，而该项目自带一个“已允许”的标记，从而在你 `cd` 进去时自动执行恶意脚本。
2. **内容敏感性**：一旦你修改了 `.envrc` 的内容，该文件的哈希值就会改变。`direnv` 会发现当前文件的哈希与 `~/.local/share/direnv/allow` 中记录的不一致，从而强制你重新运行 `direnv allow`，确保你阅读并确认了新的代码。

---

### 4. 实用技巧：如何管理这些授权？

#### A. 查看所有已授权的项目路径

你可以通过以下一行命令查看你电脑里到底给哪些目录开了“绿灯”：

```bash
find ~/.local/share/direnv/allow -type f -exec cat {} + | sort | uniq

```

#### B. 批量撤销授权

如果你想撤销所有授权（例如在安全检查时），直接清空该目录即可：

```bash
rm -rf ~/.local/share/direnv/allow/*

```

#### C. 全局白名单配置

如果你觉得每次 `allow` 太麻烦，可以在 `~/.config/direnv/direnv.toml`（如果不存在则新建）中配置白名单前缀：

```toml
[whitelist]
prefix = [
  "/Users/你的用户名/Documents/projects",
  "/Users/你的用户名/work"
]

```

这样，这些目录下的所有 `.envrc` 都会被隐式允许，无需手动敲命令。

---

### 💡 补充：与 mise 的集成

既然你之前提到了 **mise**，如果你在 `mise` 中启用了 `direnv` 支持（`mise settings set direnv true`），它会自动处理这些逻辑。但底层的信任机制依然是由 `direnv` 维护在上述路径中的。

**需要我帮你写一个 Zsh 别名（Alias），让你能一键列出当前所有“受信任”的项目并统计它们的数量吗？**
