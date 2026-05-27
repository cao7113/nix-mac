# brew

brew list --formula
brew list --cask

brew list
==> Formulae
fasd hostctl sops

==> Casks
keybase ngrok orbstack shadowsocksx-ng

## nix-darwin是 怎么 与homebrew合作的， nix-darwin 要负责homebrew的安装吗

这是一个非常关键的设计问题。简单来说：**nix-darwin 并不包含 Homebrew 的二进制代码，但它负责“声明式地接管” Homebrew。**

换句话说，nix-darwin 扮演的是一个**管理器（Manager）的角色，而 Homebrew 是它管理下的一个子系统**。

---

### 1. nix-darwin 负责安装 Homebrew 吗？

**是的，它可以负责。**

在 `nix-darwin` 的配置中，当你设置 `homebrew.enable = true;` 时，底层逻辑如下：

- **自动引导 (Bootstrapping)**：如果在激活配置时发现系统没装 Homebrew，nix-darwin 会尝试自动运行 Homebrew 的官方安装脚本。
- **权限管理**：它会确保 `/opt/homebrew` (Apple Silicon) 或 `/usr/local` (Intel) 的路径正确。
- **路径注入**：它会自动把 Homebrew 的路径（如 `brew` 命令）加进你的系统 `PATH` 环境变量中，这样你不需要在 `.zshrc` 里手动写 `eval $(brew shellenv)`。

---

### 2. 它们是如何协同工作的？

当你运行 `darwin-rebuild switch` 时，内部发生了一场“交接仪式”：

1. **解析配置**：Nix 读取你 `_system.nix` 里的 `homebrew.brews` 和 `homebrew.casks` 列表。
2. **生成 Brewfile**：Nix 会在后台自动生成一个临时文件（类似 `Brewfile`），记录你声明的所有包。
3. **调用指令**：Nix 调用 `brew bundle` 命令，对照这个列表进行安装、更新或删除。
4. **清理多余内容**：如果你开启了 `onActivation.cleanup = "zap"`，Nix 会告诉 Homebrew：“除了我给你的这张清单，其他的全部删掉。”

---

### 3. 为什么不直接在 Nix 里装所有包？

你可能会问：既然用了 Nix，为什么还要留着 Homebrew？

- **GUI 软件 (Casks)**：Nixpkgs 对 macOS 桌面应用的支持（如微信、钉钉）不如 Homebrew Cask 完善和及时。
- **App Store (MAS)**：Nix 无法直接访问苹果商店，必须通过 Homebrew 里的 `mas` 工具。
- **编译成本**：有些复杂的包在 Nix 中可能需要从源码编译很久，而 Homebrew 通常提供预编译好的二进制文件（Bottle）。

---

### 💡 协作建议：最佳实践

为了让这套合作关系最稳固，建议你在 `_system.nix` 中这样写：

```nix
homebrew = {
  enable = true;

  # 每次 switch 时自动运行 brew update
  onActivation.autoUpdate = true;

  # 每次 switch 时自动升级已安装的包
  onActivation.upgrade = true;

  # 只有在确信所有需要的包都进了配置后，再开启 zap
  # onActivation.cleanup = "zap";

  # 这里只放 Nix 搞不定的：GUI 应用和 App Store 工具
  casks = [ "wechat" "orbstack" ];
  brews = [ "mas" ];
};

```
