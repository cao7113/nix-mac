# Homebrew

Brew 装壳，Nix 装灵魂（配置/插件）

## Mirros

```
- https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
```

brew config

brew --repo homebrew/core
/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core

brew --repo homebrew/homebrew-services

## 国内镜像

Homebrew Mirrors需要4项配置。USTC最完整。
清华大学和腾讯云都缺少cask源？

## Cache

```
brew --cache bitwarden
brew --cache

brew cleanup

ls -al $(brew --cache)/downloads
```
