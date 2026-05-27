# Homebrew cask

对于 OrbStack 这种以 cask 形式安装的 GUI 应用，情况与 jq 这种命令行工具（formula）有所不同。Cask 通常被安装在 /Applications 下，而其内部的二进制文件通常会自动链接到 Homebrew 的路径中。

`$(brew --prefix)/bin/orb`
