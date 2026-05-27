# Mac loves Nix

我的 `nix-darwin` + `home-manager` 配置，使用 Determinate Nix 管理 macOS 环境。

## 概览

- 使用 `determinate-nix` 安装并管理 `nix` 版本。
- `nix-mac` 为公共仓库，基于 `nix-darwin` + `home-manager`，管理 macOS 基础软件，如 `zsh`、`postgresql` 等。
- `dot-sec` 为私有仓库，基于 `home-manager`，管理私有配置数据，包含 `sops-nix`、`age`、`ssh` 等。
- `dot-sec` 是独立 git 仓库，软链接到 `~/.sec`，作为 `home-manager` 可选子模块。
  - 当 `~/.sec` 存在时，会随 `darwin-rebuild` 一起部署。
  - 不存在时不会影响 `nix-darwin` 部署，仅提示缺失。

## 快速开始

1. 安装 Determinate Nix。
2. 克隆 `nix-mac` 仓库。
3. 运行 `darwin-rebuild` 切换配置。
4. 执行 `iup` 进行后续初始化。

## 安装与初始化

### 1. 前置准备

- 登录 Apple ID，保证网络畅通。
- 安装 `Homebrew`、`Xcode Command Line Tools` 时可能需要较多下载。

### 2. 安装 Determinate Nix

推荐使用 Determinate Nix Installer：

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

如果需要 pkg 安装包，可参考：

- https://docs.determinate.systems/getting-started/individuals/
- https://install.determinate.systems/determinate-pkg/stable/Universal

参考文档：

- https://zenn.dev/trifolium/articles/da11a428c53f65?locale=en
- https://github.com/NixOS/nix-installer
- https://github.com/DeterminateSystems/nix-installer

测试安装：

```bash
nix profile add nixpkgs#hello -vv
```

### 3. 安装 `nix-mac`

```bash
mkdir -p ~/dev && cd ~/dev
git clone -v --depth=3 https://github.com/cao7113/nix-mac.git
cd nix-mac
sudo nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake .#mac --show-trace --impure
# 然后执行
iup
```

### 4. 安装 Xcode 命令行工具

```bash
xcode-select --install
```

如果出现以下提示，则需要安装开发工具：

> xcode-select: note: No developer tools were found, requesting install.

如果开发工具位于非默认路径，可使用：

```bash
sudo xcode-select --switch path/to/Xcode.app
```

检查当前路径：

```bash
xcode-select -p
```

## 说明与建议

### Homebrew

如果网络不好，可在 `flake.nix` 中临时注释掉 Homebrew 部分配置。

### VSCode 扩展

推荐安装 `jnoortheen.nix-ide`：

- https://github.com/nix-community/vscode-nix-ide?tab=readme-ov-file#language-servers

### Flakehub CLI (`fh`)

安装：

```bash
nix profile add github:DeterminateSystems/fh
```

临时 shell 安装：

```bash
nix shell "https://flakehub.com/f/DeterminateSystems/fh/*"
```

示例用法：

```bash
nix shell nixpkgs#hello
nix shell nixpkgs#pkg1 nixpkgs#pkg2
nix shell nixpkgs#hello --command hello --version
nix shell github:NixOS/nixpkgs/nixos-unstable#hello
nix run nixpkgs#cowsay -- "Hello"
```

运行后：

```bash
nix run github:DeterminateSystems/fh -- --help
nix run nixpkgs#hello -- --version
```

检查版本：

```bash
fh --version
```

### 生成初始 SSH Key

```bash
gh auth login
gh ssh add ~/.ssh/id_ed25519.pub
```

### GitHub API 访问限额

建议参考：

- https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional

### 代理设置

网络不稳定时可使用 ShadowsocksNG 代理：

```bash
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
```

## 参考链接

- https://callistaenterprise.se/blogg/teknik/2025/05/28/nix-darwin/
- https://github.com/HestHub/nixos
- https://github.com/nix-darwin/nix-darwin
- https://nix-darwin.github.io/nix-darwin/manual/index.html
- https://home-manager-options.extranix.com/?query=direnv&release=release-25.11
- https://nix.dev/manual/nix/2.28/introduction.html
- https://github.com/NixOS/flake-registry/blob/master/flake-registry.json
- https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#examples
