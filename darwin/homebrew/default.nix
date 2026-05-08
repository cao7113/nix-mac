{
  config,
  pkgs,
  lib,
  ...
}:
{
  ## This file is imported by _darwin.nix

  ## NOTE: require MANUAL install brew before using homebrew module
  homebrew = {
    enable = true;

    # 注入环境变量，让 Homebrew 打印详细日志
    onActivation.extraFlags = [
      "--verbose"
      # "--debug" # 需要更多调试信息时启用
    ];
    # 或者通过全局环境变量（更彻底）
    # environment.variables.HOMEBREW_VERBOSE = "1";

    # onActivation.autoUpdate = true;
    # onActivation.upgrade = true;

    # ⚠️ 警告：启用 zap 会删除所有不在下面列表中的手动安装包 自动卸载不在列表中的包，实现真正的“声明式”
    onActivation.cleanup = "zap"; # "none";

    brews = [
      # mas 是一个命令行工具，用于从 Mac App Store 安装和管理应用程序。它提供了一个方便的接口，让你可以直接在终端中搜索、安装、更新和卸载通过 App Store 提供的应用。
      "mas"
    ];

    # GUI 软件通常放在 casks
    casks = [
      # keep installed when auto cleanup is enabled
      # "shadowsocksx-ng"
      # better than nixpkgs bitwarden-desktop
      "bitwarden"
      # "iterm2"
      # "visual-studio-code"
      # "wechat" # 添加微信
      "orbstack" # Docker Desktop 替代品，适合 M1/M2 芯片
    ];

    ## mas（Mac App Store 命令行界面） brew info mas

    # 要在你的 nix-darwin 环境中安装并启用 mas（Mac App Store 命令行界面），最标准且集成度最高的方式是通过你现有的 homebrew 配置。
    # 如果你有需要从 App Store 下载的（需安装 mas）
    # 使用 masApps 声明你想要的 App Store 应用
    # 格式为 "应用名称" = AppleID;
    masApps = {
      # get appleID: mas search "微信"
      "WeChat" = 836500024; # 微信的 App Store ID
      # "Bitwarden" = 1352778147;
      # "Magnet" = 441258766; # 举例：如果你买过这些应用
    };
    # mas 无法帮你自动处理 Apple ID 的登录。如果报错提示未登录，请先手动打开 App Store.app 并登录你的账号。
    # 验证安装：
    # 安装完成后，你可以运行： mas list
    # 它会列出所有通过 App Store 安装的应用及其对应的 ID。
  };

}
