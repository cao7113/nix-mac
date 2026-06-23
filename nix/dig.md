# dig

## 官方默认安装中与nixpkgs的关系

使用nix profile add pkg时是如何查找软件的，这个nixpkgs是在哪里指定的哪个版本
对比不同，如何设置成一样的？


```
darwinConfigurations.macbook = nixpkgs.lib.nix_darwinSystem {
      modules = [
        ({ config, pkgs, ... }: {
          # 让系统的 nix registry 中的 nixpkgs 直接指向当前 flake 的 inputs.nixpkgs
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          
          # 同时让传统的 NIX_PATH 也指向它，让老命令也享受确定性
          nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        })
      ];
    };
```

## use-xdg-base-directories

`nix config show`
默认安装的配置是`use-xdg-base-directories = false`，
如何使用官方脚本安装的nix，自动就是`use-xdg-base-directories = true`？
如何升级改变？

如果切换到比较现代的nix-commands flake模式，能删除 ~/.nix-defexp 和 ~/.nix-profile目录吗
不行的话如何迁移，有何影响

```
export NIX_EXTRA_CONF="use-xdg-base-directories = true"
curl -L https://nixos.org/nix/install | sh

nix.channel.enable = false;

home-manager.useUserPackages = true;

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --extra-conf "use-xdg-base-directories = true"
```