# Determinate

## Determinate Nix

- https://docs.determinate.systems/determinate-nix/
- https://manual.determinate.systems/introduction.html

Determinate Nix has two core components:

- Our downstream distribution of the Nix CLI.
- Determinate Nixd, a daemon that makes your experience of installing and using Nix dramatically more smooth.

## Path

- 安装Determinate Nix Installer后，如何安装FlakeHub 提供的 CLI 工具 fh
  - 临时： nix run https://flakehub.com/f/DeterminateSystems/fh/0.1
  - 永久： nix profile install https://flakehub.com/f/DeterminateSystems/fh/0.1

    environment.systemPackages = [
    pkgs.htop
    inputs.determinate.packages.${system}.default # 添加这一行来引用 determinate 提供的 fh
    ];

配置
有疑问fh有对应的仓库https://github.com/DeterminateSystems/fh
而 https://github.com/DeterminateSystems/determinate/blob/main/flake.nix#L50
的packages.default并没有指向 fh啊，这是怎么回事呢？

- use nix-darwin
