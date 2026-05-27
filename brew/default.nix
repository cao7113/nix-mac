{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # disabled by set: config.brewer.brew.enable = false;

  options.brewer.brew = {
    enable =
      with lib;
      mkOption {
        type = types.bool;
        default = true; # 默认启用 Homebrew
        description = "Whether to enable Homebrew and manage bundle packages.";
      };
  };

  config = lib.mkIf config.brewer.brew.enable {
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
        # basics
        "iterm2"

        # try Brave https://alternativeto.net/browse/all/?tag=web-browser
        "google-chrome"

        "visual-studio-code"
        "notion"

        # AI app
        "yuanbao"

        # "shadowsocksx-ng"

        # Docker Desktop 替代品
        "orbstack"
      ];

      ## mas（Mac App Store 命令行界面） brew info mas

      # 要在你的 nix-darwin 环境中安装并启用 mas（Mac App Store 命令行界面），最标准且集成度最高的方式是通过你现有的 homebrew 配置。
      # 如果你有需要从 App Store 下载的（需安装 mas）
      # 使用 masApps 声明你想要的 App Store 应用
      # 格式为 "应用名称" = AppleID;
      masApps = {
        # for Safari extensions, brew-cask版本仅支持chrome和firefox
        "Bitwarden" = 1352778147;

        "WeChat" = 836500024; # 微信的 App Store ID
        # "Magnet" = 441258766; # 举例：如果你买过这些应用
      };
      # mas 无法帮你自动处理 Apple ID 的登录。如果报错提示未登录，请先手动打开 App Store.app 并登录你的账号。
      # 验证安装：
      # 安装完成后，你可以运行： mas list
      # 它会列出所有通过 App Store 安装的应用及其对应的 ID。
    };

    home-manager.users.${username} = {
      programs.zsh.initContent = ''
        echo "Initializing Homebrew environment for ${username}..."
        # 让 Homebrew 的环境变量生效 (如果你通过 Homebrew 安装了某些工具，这一步很重要)
        if [[ -e /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv zsh)"
        fi
      '';
    };
  };

}
