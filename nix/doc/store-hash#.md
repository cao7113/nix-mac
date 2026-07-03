## hash sign

在 Zsh 环境下，`#` 被视为一种名为 **扩展通配符（Extended Globbing）** 的特殊字符。当你输入 `nixpkgs#htop` 时，Zsh 会尝试在本地寻找匹配该模式的文件。因为找不到，所以抛出 `zsh: no matches found` 错误。

以下是针对不同使用习惯的四种解决方案：

---

### 1. 临时方案：引号或转义（最稳妥）

这是最直接的方法，通过引号或反斜杠告诉 Zsh 不要解析 `#`。

- **双引号/单引号**：

```bash
nix shell "nixpkgs#htop" -c htop

```

- **反斜杠转义**：

```bash
nix shell nixpkgs\#htop -c htop

```

---

### 2. 局部方案：使用 `noglob` 别名（最推荐）

如果你经常使用 `nix` 相关命令，可以设置一个别名，让 Zsh 在执行 `nix` 命令时自动禁用通配符解析。

在你的 `~/.zshrc` 文件中添加：

```zsh
alias nix='noglob nix'

```

**效果**：之后你直接输入 `nix shell nixpkgs#htop` 就不再需要引号，也不会报错了。

---

### 3. 全局方案：禁用通配符报错（不推荐）

你可以通过修改 Zsh 选项，让它在找不到匹配文件时不再报错，而是将原始字符串传给程序。

在 `~/.zshrc` 中添加：

```zsh
unsetopt nomatch

```

> **缺点**：这会改变 Zsh 的全局行为。如果你平时习惯利用 Zsh 的报错来发现拼写错误的路径，这个设置会让错误变得隐蔽。

---

### 4. 彻底方案：关闭解释为注释的行为（针对交互式命令行）

虽然报错通常是因为 Globbing，但有时是因为 Zsh 将 `#` 后的内容视为了注释。确保你的设置中没有开启 `INTERACTIVE_COMMENTS`（通常默认是关闭的）。

检查设置：

```zsh
unsetopt interactive_comments

```

---

### 总结与建议

| 方案                   | 推荐度     | 优点                    | 缺点                      |
| ---------------------- | ---------- | ----------------------- | ------------------------- |
| **引号包裹**           | ⭐⭐⭐⭐   | 简单、无需改配置        | 每次都要多打两个字符      |
| **`noglob` 别名**      | ⭐⭐⭐⭐⭐ | **丝滑**，专治 Nix 语法 | 仅对 `nix` 开头的命令有效 |
| **`unsetopt nomatch`** | ⭐⭐       | 一劳永逸                | 容易掩盖真正的路径错误    |

**下一步建议：**
如果你选择方案 2，请在终端执行 `echo "alias nix='noglob nix'" >> ~/.zshrc && source ~/.zshrc`。

**现在尝试输入 `nix shell nixpkgs#htop -c htop`，是不是已经可以直接运行了？**
