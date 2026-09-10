{ config, pkgs, ... }:
{
  # 因为nix-darwin的dnsmasq模块支持的配置有限，如不支持cname等
  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/services/dnsmasq.nix
  services.dnsmasq = {
    enable = false;

    # addresses = {
    #   ".h" = "127.0.0.1";
    # };
  };

  # 明确安装 dnsmasq 到系统环境中，方便终端直接调用
  environment.systemPackages = [
    pkgs.dnsmasq
  ];

  # 声明式生成 /etc/resolver 配置，确保 macOS 将特定顶级域定向到本地 dnsmasq
  environment.etc = {
    "dnsmasq.conf".source = ./config.conf;

    "resolver/h".text = "nameserver 127.0.0.1\n";
    "resolver/l".text = "nameserver 127.0.0.1\n";
    "resolver/s".text = "nameserver 127.0.0.1\n";
  };

  # 自定义 launchd 守护进程
  launchd.daemons.dnsmasq = {
    script = "${pkgs.dnsmasq}/bin/dnsmasq --keep-in-foreground --conf-file=/etc/dnsmasq.conf";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/dnsmasq.err.log";
      StandardOutPath = "/tmp/dnsmasq.out.log";
    };
  };
}
