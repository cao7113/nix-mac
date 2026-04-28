{
  config,
  pkgs,
  lib,
  ...
}:
{
  # nix --version
  # nix (Determinate Nix 3.17.1) 2.33.3

  determinateNix = {
    # 重命名冲突的配置文件
    # sudo mv /etc/nix/nix.custom.conf /etc/nix/nix.custom.conf.before-nix-darwin

    # Enable Determinate to handle your Nix configuration
    enable = true;

    # Custom Determinate Nix settings written to /etc/nix/nix.custom.conf
    customSettings = {
      # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
      eval-cores = 0;
      extra-experimental-features = [
        "build-time-fetch-tree" # Enables build-time flake inputs
      ];

      # 1. 代理配置（核心：针对你的 Shadowsocks 1087 端口）
      # 注意：这里必须是字符串格式
      # http-proxy = "http://127.0.0.1:1087";
      # https-proxy = "http://127.0.0.1:1087";
      # 现代 Nix 推荐的代理配置方式
      # 注意：Nix 会自动处理 http/https 的分发
      # download-proxy = "http://127.0.0.1:1087";

      # 1. 优先使用国内镜像站
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://cache.flakehub.com" # 3. Flakehub 专用缓存（国内无镜像，需直连）
      ];
      # 2. 这里的公钥必须保留，否则镜像站的包无法通过校验
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "flakehub.com-1:7B9E0L0FeSioEn6L/ISdVvPkOoDnWMx8DswHxnTIbhg=" # 必须添加 Flakehub 的公钥
      ];
    };

  };

  # todo write proxy Switch shell command

  # 注入代理环境变量到 nix-daemon 进程
  # 这会影响所有 build 过程中的 fetcher（如 fetchgit, fetchurl）
  # 注意：这需要较新版本的 nix-darwin 模块支持
  # launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables = {
  #   http_proxy = "http://127.0.0.1:1087";
  #   https_proxy = "http://127.0.0.1:1087";
  # };

  # nix.settings = {
  #   # 以后所有的 nix 下载和构建都会走这个代理
  #   http-proxy = "http://127.0.0.1:1087";
  #   https-proxy = "http://127.0.0.1:1087";
  # };

  # # 针对 Go 模块下载的全局优化
  # environment.variables = {
  #   GOPROXY = "https://goproxy.cn,direct";
  # };
}
