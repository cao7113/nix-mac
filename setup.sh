#!/usr/bin/env zsh
set -e

# zsh -c "$(curl -fsSL https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.sh)"

echo "=== 开始设置 nix-mac 环境 ==="

echo "!!! 请确保网络连接正常 & 登陆了Apple ID账号"

# 1. 检查并安装 Xcode Command Line Tools
echo "--- 检查 Xcode Command Line Tools ---"
if ! xcode-select -p &>/dev/null; then
    echo "正在安装 Xcode Command Line Tools..."
    xcode-select --install
    # 等待安装完成
    echo "请在弹出的窗口中完成安装，然后按回车键继续..."
    read
else
    echo "✓ Xcode Command Line Tools 已安装"
fi

# 2. 安装 Homebrew
echo "--- 检查 Homebrew ---"
BREW_PATH="/opt/homebrew/bin/brew"
if [[ -f "$BREW_PATH" ]]; then
    echo "✓ Homebrew 已安装: $BREW_PATH"
else
    echo "正在安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 将 Homebrew 添加到 PATH
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    # eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "✓ Homebrew 安装完成"
fi

# 3. 安装 Determinate Nix
echo "--- 检查 Nix ---"
NIX_PATH="/nix/var/nix/profiles/default/bin/nix"
if [[ -f "$NIX_PATH" ]] || command -v nix &>/dev/null; then
    echo "✓ Nix 已安装"
else
    echo "正在安装 Determinate Nix..."
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
    
    # 加载 Nix 环境
    # if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    #     . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    # fi
    echo "✓ Nix 安装完成"
fi

# 4. 设置 nix-mac 代码
echo "--- 设置 nix-mac 配置 ---"
NIX_MAC_DIR="$HOME/dev/nix-mac"
if [[ -d "$NIX_MAC_DIR" ]]; then
    echo "✓ nix-mac 目录已存在: $NIX_MAC_DIR"
    cd "$NIX_MAC_DIR"
    echo "拉取最新更改..."
    git pull
else
    echo "正在克隆 nix-mac 仓库..."
    mkdir -p "$HOME/dev"
    cd "$HOME/dev"
    git clone https://github.com/cao7113/nix-mac.git
    
    if [[ $? -ne 0 ]]; then
        echo "错误: 无法克隆仓库"
        exit 1
    fi
    
    cd nix-mac
    echo "✓ nix-mac 仓库克隆完成"
fi

# 5. 应用 nix-mac 配置
echo "--- 应用 nix-mac 配置 ---"
NIX_MAC_OK_FILE="$NIX_MAC_DIR/.installed_ok"

if [[ -f "$NIX_MAC_OK_FILE" ]]; then
    echo "✓ nix-mac 已配置完成"
    echo "要重新应用配置，请运行: nix run nix-darwin#darwin-rebuild -- switch --flake .#mac"
else
    echo "正在应用 nix-mac 配置..."
    
    # 确保在正确的目录
    cd "$NIX_MAC_DIR"
    
    # 检查是否有 flake.nix 文件
    if [[ ! -f "flake.nix" ]]; then
        echo "错误: 在 $NIX_MAC_DIR 中找不到 flake.nix 文件"
        exit 1
    fi
    
    echo "运行 nix-darwin 配置..."
    
    # 使用 sudo 运行，但先检查是否需要
    if [[ $EUID -eq 0 ]]; then
        nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --impure --flake .#mac --show-trace
    else
        sudo nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --impure --flake .#mac --show-trace
    fi
    
    if [[ $? -eq 0 ]]; then
        touch "$NIX_MAC_OK_FILE"
        echo "✓ nix-mac 配置应用成功！"
    else
        echo "错误: nix-darwin 配置失败"
        echo "请检查错误信息并手动修复"
        exit 1
    fi
fi

echo ""
echo "========================================"
echo "🎉 恭喜！nix-mac 环境设置完成！"
echo "========================================"
echo ""
echo "后续操作建议："
echo "1. 重新打开终端或运行: source ~/.zshrc"
echo "2. 如需更新配置，进入 ~/dev/nix-mac 目录运行:"
echo "   nix run nix-darwin#darwin-rebuild -- switch --flake .#mac"
echo "3. 查看当前配置: darwin-rebuild report"
echo ""
