{
  self,
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # https://nix-darwin.github.io/nix-darwin/manual/index.html

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;

  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    # 指定用户家目录，Home Manager 依赖此路径
    # check by: nix eval .\#darwinConfigurations.mac.config.users.users.rj.home
    home = "/Users/${username}";
    # See the reference docs for more on user config:
    # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users
    # packages = [];
  };

  # scutil --get HostName | ComputerName | LocalHostName
  # 1. 核心设置：这会影响 shell 提示符和网络识别
  networking.hostName = "mac";
  networking.localHostName = "mac";
  networking.computerName = "Ryn's Mac";
  # 2. 这里的设置确保系统偏好设置中的名字也随之同步
  system.defaults.smb.NetBIOSName = "mac";

  imports = [
    ./determinate.nix
    ./pkgs.nix
    ./homebrew
    # launchd/test.nix
  ];

  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.enable = false;
  # security.pam.services.sudo_local.touchIdAuth = false;

  # environment.variables = {
  #   # nh 核心配置：flake.nix 所在的绝对路径
  #   # (可选) nh 需要一些底层的工具支持, nh clean 功能依赖 nix-collect-garbage
  #   NH_FLAKE = "/Users/${user}/.nix";
  # };

  environment.shellAliases = {
    machi = "echo hello from nix-darwin config file shell alias";
  };

  system.defaults = {
    # check cmd: defaults read com.apple.dock autohide # return 1
    # killall Dock # or 重启 Dock 使其应用新设置
    dock.autohide = true;
    # defaults read com.apple.finder AppleShowAllExtensions
    # killall Finder # 重启 Finder 使其显示后缀
    finder.AppleShowAllExtensions = true;
    # defaults read -g AppleInterfaceStyle
    NSGlobalDomain.AppleInterfaceStyle = "Dark"; # 开启深色模式
  };

  # 键盘映射 todo

  # Other configuration parameters
  # See here: https://nix-darwin.github.io/nix-darwin/manual
}
