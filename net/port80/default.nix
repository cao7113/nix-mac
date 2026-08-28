{
  config,
  pkgs,
  lib,
  ...
}:
{
  # 配合dnsmasq的 *.lab 域名方便本地访问使用，如 http://admin.lab
  # 查看配置效果
  # sudo pfctl -s nat
  # # rdr pass on lo0 inet proto tcp from any to any port = 80 -> 127.0.0.1 port 8888
  # sudo pfctl -s info

  # 1. 确保 Hosts 映射正确, use dnsmasq instead
  # networking.hosts = ''
  #   127.0.0.1 admin.lab
  # '';

  # 2. 创建自定义 PF 规则文件
  environment.etc."pf.anchors/lab.port80.pf.conf".text = ''
    rdr pass log on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8888
  '';

  # 3. 创建系统级守护进程（root权限）在开机时加载 PF 规则
  launchd.daemons.pf-port80-forward = {
    script = ''
      /sbin/pfctl -e || true
      /sbin/pfctl -f /etc/pf.anchors/lab.port80.pf.conf
    '';
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = false; # 执行一次即可
      StandardOutPath = "/tmp/pf-port80-forward.log";
      StandardErrorPath = "/tmp/pf-port80-forward.err.log";
    };
  };

  # networking.pf 在 nix-darwin 中并不是原生的选项（networking.pf 是 NixOS 的选项，在 macOS / nix-darwin 上不存在）
  # # 开启 PF 防火墙服务
  # networking.pf.enable = true;
  # 配置 PF 转发规则
  # 将到达 loopback 接口(lo0) 80 端口的 TCP 流量重定向到 8888
  # networking.pf.config = ''
  #   rdr pass on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8888
  # '';
}
