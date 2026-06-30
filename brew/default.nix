{
  config,
  pkgs,
  lib,
  username,
  need_least,
  current_level,
  ...
}:
{
  # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  homebrew = {
    enable = (need_least "brewer");

    # 注入环境变量，让 Homebrew 打印详细日志
    onActivation.extraFlags = [
      "--verbose"
      # "--debug" # 需要更多调试信息时启用
    ];
    # 或者通过全局环境变量（更彻底）
    # environment.variables.HOMEBREW_VERBOSE = "1";

    # brew update
    # onActivation.autoUpdate = true;
    # onActivation.upgrade = true;

    # ⚠️ 警告：启用 zap 会删除所有不在下面列表中的手动安装包 自动卸载不在列表中的包，实现真正的“声明式”
    # 自动清理不再需要的包和外挂
    # onActivation.cleanup = "zap"; # "none";

    brews = lib.optionals (need_least "all") [
      # mas CLI用于从 Mac App Store 安装和管理应用。直接在终端中搜索、安装、更新和卸载通过 App Store 提供的应用。
      "mas"
    ];

    casks = lib.optionals (need_least "all") [
      # "shadowsocksx-ng"
      # AI app
      "yuanbao"
    ];

    ## mas（Mac App Store 命令行界面） brew info mas
    # 要在你的 nix-darwin 环境中安装并启用 mas（Mac App Store 命令行界面），最标准且集成度最高的方式是通过你现有的 homebrew 配置。
    # 如果你有需要从 App Store 下载的（需安装 mas）
    # 使用 masApps 声明你想要的 App Store 应用
    # 格式为 "应用名称" = AppleID;
    # masApps = lib.mkIf (need_least "all") {
    #   # for Safari extensions, brew-cask版本仅支持chrome和firefox
    #   "Bitwarden" = 1352778147;
    #   "WeChat" = 836500024; # 微信的 App Store ID
    #   # "Magnet" = 441258766; # 举例：如果你买过这些应用
    # };
    # mas 无法帮你自动处理 Apple ID 的登录。如果报错提示未登录，请先手动打开 App Store.app 并登录你的账号。
    # 验证安装：
    # 安装完成后，你可以运行： mas list
    # 它会列出所有通过 App Store 安装的应用及其对应的 ID。
  };

  home-manager.users.${username} = {
    programs.zsh.initContent = lib.mkIf (need_least "brewer") (
      # Adjust how often this is run with `$HOMEBREW_AUTO_UPDATE_SECS` or disable with `$HOMEBREW_NO_AUTO_UPDATE=1`. Hide these hints with `$HOMEBREW_NO_ENV_HINTS=1` (see `man brew`).
      lib.mkBefore ''
        echo "# Initializing Homebrew environment for ${username}..."
        # 让 Homebrew 的环境变量生效
        if [[ -e /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        # 3600 * 24 * 7
        export HOMEBREW_AUTO_UPDATE_SECS=604800
      ''
    );
  };
}
