# Official Scripts to install

- https://nix.dev/install-nix
- https://nix.dev/manual/nix/2.34/installation/index.html

```
curl -L https://nixos.org/nix/install | sh -s -- --daemon
curl -L https://nixos.org/nix/install | sh

# --tarball-url-prefix <cachix-url-prefix> --help # and other options
# https://releases.nixos.org/nix/nix-2.34.7/nix-2.34.7-aarch64-darwin.tar.xz # default tarball url

# https://releases.nixos.org/?prefix=nix/nix-2.34.7/
export VERSION=2.34.7
curl -L https://releases.nixos.org/nix/nix-$VERSION/install | sh
```

## 运行成功了

```
nix-shell -p nix-info --run "nix-info -m"
```

## 原理解读

- 下载安装包(约17.2M)并运行其中的安装脚本install
- 下载包包含什么？
- 默认时single-user模式，macOS下要传参`--daemon` 使用`multi-user`模式 
- How to uninstall？ 直接安装就行，有问题会提示uninstall
  - https://nix.dev/manual/nix/2.34/installation/uninstall.html#macos

## others

- [Legacy distributions installer for (rpm & deb & pacman)](https://github.com/nix-community/nix-installers)

