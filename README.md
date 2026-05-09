# Ryn's nix-config mainly for MacOS

My daily nix-darwin and home-manager config on Determinate Nix

## How to use?

```
# init setup
todo

# then
iup
```

## Overview

determinate-nix installer 管理nix版本安装

nix-mac仓库是public的，架构是flake based nix-darwin + home-manager, 管理mac基础软件安装，如 zsh，postgresql等

dot-sec仓库是private的，架构是 flake based home-manager，管理私有配置数据，包含sops-nix，age，ssh等

dot-sec本身是独立的git仓库，在~/dev/ops/dot-sec，并软链接到~/.sec

dot-sec 设计为nix-mac下 home-manager可选子模块。当~/.sec存在时，跟随darwin-rebuild进行相关部署；不存在时也不影响nix-darwin部署，但给出提示~/.sec不存在
