# [Nix](https://nix.dev)

A purely functional package manager.

```
 % nix-shell -p cowsay lolcat --run "cowsay Hello, Nix! | lolcat"
 _____________
< Hello, Nix! >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

- [Nix core](https://github.com/NixOS/nix)
- https://nixos.org/
- https://nix.dev/reference/nix-manual
- https://github.com/NixOS/nixpkgs

## How to

- how to list all installed packages?
- nix store packages group by package-name part (split out hash and version), get top
- how to view package dependency graph?
- what's substitutes and derivation?
- what's the search paths and lookup paths?

## config

```
# 1. 创建并把实验性特性写入配置文件，以后就不用每次都手动敲这两项了
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 2. 顺便把软件成品的下载服务器也改成上海交大镜像，大幅加速后续的下载
echo "substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org" >> ~/.config/nix/nix.conf

# 3. 将全局的 nixpkgs 注册表永久重定向到清华大学的 Git 镜像源
nix registry add nixpkgs git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixpkgs-unstable
# 替换为 25.11 稳定版分支（或者 26.05，取决于当时最新的稳定版，稳定版极少需要排队实时同步）
nix registry add nixpkgs git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixpkgs-26.05-darwin
release-26.05

sudo sh -c "echo 'trusted-users = root $(whoami)' >> /etc/nix/nix.conf"

sudo launchctl bootstrap system/org.nixos.nix-daemon

sudo launchctl kickstart -k system/org.nixos.nix-daemon
sudo launchctl list|grep nix

tail -f /var/log/nix-daemon.log
```

## tips

```
rj@mac nix-mac % nix profile add nixpkgs#hello
warning: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Timeout was reached (28) Resolving timed out after 15000 milliseconds; retrying in 252 ms (attempt 1/5)
warning: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Timeout was reached (28) Resolving timed out after 15000 milliseconds; retrying in 661 ms (attempt 2/5)
warning: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Timeout was reached (28) Resolving timed out after 15001 milliseconds; retrying in 1174 ms (attempt 3/5)
warning: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Timeout was reached (28) Resolving timed out after 15000 milliseconds; retrying in 2405 ms (attempt 4/5)
error:
       … while fetching the input 'github:NixOS/nixpkgs/nixpkgs-unstable'

       error: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Timeout was reached (28) Resolving timed out after 15001 milliseconds
```

```
# -p is --package
nix-shell -p cowsay lolcat
nix-shell -p nix-info --run "nix-info -m"

# nix profile modern way
nix profile add nixpkgs#hello --extra-experimental-features nix-command --extra-experimental-features flakes

# old style deprecated using nix-channel
nix-env -iA nixpkgs.hello
nix-env --install --file '<nixpkgs>' --attr hello --dry-run
nix-env --install --attr nixpkgs.firefox
nix-env --install --attr nixpkgs.go-task --dry-run
nix-env --upgrade --attr nixpkgs.some-package
nix-env --rollback
nix-env --uninstall firefox

nix-collect-garbage

builtins.currentSystem

nix-env --install --attr pkgname --arg system \"i686-freebsd\" # --argstr system i686-linux
# (Note that since the argument is a Nix string literal, you have to escape the quotes.)
```

## binary cache

- https://cache.nixos.org/b6gvzjyb2pg0….narinfo

## packages

- https://search.nixos.org/packages

## try

- https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/go/go-task/package.nix

```
nix-shell '<nixpkgs>' --attr pan

# You’re then dropped into a shell where you can edit, build and test the package:

 unpackPhase
 cd pan-*
 configurePhase
 buildPhase
 ./pan/gui/pan
```