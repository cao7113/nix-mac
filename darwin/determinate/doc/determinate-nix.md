# Determinate Systems

- nix vendor
- flakehub.com
- friendly installer on macos and uninstaller


## Nix Daemon

Determinate Installer安装的nix版本，负责后台下载网络包的程序是哪个？
Mac下是否和下面的plist有关？
/Library/LaunchDaemons/systems.determinate.nix-daemon.plist
如何添加网络代理，加快下载速度？

https://gemini.google.com/app/1c3408a9542c3b2c
通过 Determinate Installer 安装 Nix 后，负责后台处理所有构建、下载和包管理的程序是 nix-daemon。