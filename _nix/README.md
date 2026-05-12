# Manage your macOS using Nix

- https://github.com/nix-darwin/nix-darwin
- https://nix-darwin.github.io/nix-darwin/manual/index.html
- https://home-manager-options.extranix.com/?query=direnv&release=release-25.11
- https://nix.dev/manual/nix/2.28/introduction.html

## Intaller

- https://zenn.dev/trifolium/articles/da11a428c53f65?locale=en
- [a fork of the Determinate Nix Installer](https://github.com/NixOS/nix-installer)
- https://github.com/DeterminateSystems/nix-installer

## How to use？

### 整体思路

- 登录Apple账户 & 可进入命令行
- 一键-通用安装nix-darwin（脚本驱动，包括基本工具和secrets工具等）
- 一键-私有配置（本机生成key或从keychain等获取）

## todos

- sops-nix
- write a package and programs and home-manager service
- 配置一下 security.pam.services.sudo_local.touchIdAuth = true; 来开启终端 sudo 时的指纹解锁

## 路径

```
由于 macOS 的限制，Nix 不能像 Linux 那样随意修改 /usr/bin。它通过“层层引用”来管理路径：
/run/current-system/sw/bin: 这是当前激活系统的“主开关”目录。
/etc/static/...: 这是 nix-darwin 放置静态配置文件的位置，由它接管系统的 /etc。
~/.nix-profile/bin: 这是用户级别的软件路径。
```

极致的环境隔离性和配置可复用性

nix-darwin + home-manager

macOS 上，单跑 Nix 只能管理包。要真正替代 Brew 的系统级管理功能，你需要这两大工具：

nix-darwin：管理 macOS 系统设置（类似 Brew 的底层权限）。

home-manager：管理用户配置文件（Dotfiles）和用户级软件。

在 M1 Mac 上，你可以让 nix-darwin 管理系统级设置（如 Dock、键盘），让 home-manager 管理你的用户软件，两者完美融合。

Nix-darwin + Home-manager + Flakes。

Nix 求值带来的 CPU 压力。这也是为什么大厂会使用 Hercules-CI 或 Hydra 这样的持续集成工具来预先计算好结果

## config

```
vi /etc/nix/nix.conf
ls ~/.nix-profile

## store path hash
$$StorePath = Hash(Sources + Inputs + BuildScript + EnvVars + System)$$
```

## pkgs

- https://github.com/NixOS/nixpkgs/tree/nixpkgs-unstable
- nixpkgs registry

## Registry

- https://github.com/NixOS/flake-registry/blob/master/flake-registry.json

## Flake ref

- https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#examples

```
github:edolstra/nix-warez?dir=blender
# A flake in a subdirectory of a GitHub repository
```

## Nix env setup

- xcode-select --install
- Install Determinate Nix
  - https://install.determinate.systems/determinate-pkg/stable/Universal
  - https://docs.determinate.systems/

- Hello Nix
  - nix profile add nixpkgs\#hello -vv # hello
- Install VSCode extension: jnoortheen.nix-ide
  - https://github.com/nix-community/vscode-nix-ide?tab=readme-ov-file#language-servers
  - nix profile add "nixpkgs#nixd" "nixpkgs#nixfmt"
    - nixd --version
    - nixfmt --version
    - nix profile list
    - nix profile remove nixfmt
  - Cmd + Shift + P 打开settings.json
- Install fh - Flakehub CLI https://docs.determinate.systems/flakehub/cli/
  - profile install
    nix profile add github:DeterminateSystems/fh
  - current shell only
    nix shell "https://flakehub.com/f/DeterminateSystems/fh/*"
    nix shell nixpkgs\#hello (使用registry中的nixpkgs)
    nix shell nixpkgs#pkg1 nixpkgs#pkg2
    nix shell nixpkgs\#hello --command hello --version
    nix shell github:NixOS/nixpkgs/nixos-unstable#hello
    nix run nixpkgs\#cowsay -- "Hello"
  - once run (long build...)
    nix run github:DeterminateSystems/fh -- --help
    nix run nixpkgs\#hello -- --version
  - check: fh --version
- nix-darwin with determinate nix and module
- nix-darwin with home-manager
- pg service
  - nix profile add "nixpkgs#pgcli"
  - nix profile remove pgcli

- direnv
- git config

### direnv and nix-direnv???

vs-code Direnv 扩展 (mkhl.direnv)。
配合 nix-direnv使用
