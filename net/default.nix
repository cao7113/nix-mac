{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # 注意：Nix 安装的 curl 会覆盖macOS 自带的 /usr/bin/curl，可能会导致一些问题(如证书信用链，可通过环境变量SSL_CERT_FILE解决）)。
    # CURL_CA_BUNDLE to the path of your choice. SSL_CERT_FILE and SSL_CERT_DIR are also supported
    curl
  ];

  imports = [
    ./dns/dnsmasq
    # ./port80
    ./caddy
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
  # };

}
