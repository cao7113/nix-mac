{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  imports = [
    ./wireguard
  ];

  homebrew = {
    # 1. 对应：brew tap teamookla/speedtest
    taps = [
      # manually run: brew trust teamookla/speedtest
      "teamookla/speedtest"
    ];

    # 2. 对应：brew install speedtest
    # 注意：Ookla 的 speedtest 是命令行工具，但在 brew 模块中，
    # 如果它是作为一个独立的二进制分发，通常写在 brews 里。
    brews = [
      "speedtest"
    ];
  };

  # home-manager.users.${username} = {
  #   programs.xxx = {
  #   };
  # };

}
