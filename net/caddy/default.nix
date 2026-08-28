{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    caddy
  ];

  # 1. 确保创建保存证书的持久化目录
  system.activationScripts.postActivation.text = ''
    mkdir -p /var/lib/caddy
  '';

  # /etc/caddy/Caddyfile 配置 Caddy 监听 80/443 并反向代理到
  # not support *.lab tld
  # NOTE: restart caddy service after change this config!!!
  environment.etc."caddy/Caddyfile".text = ''
    {
      admin localhost:2019
    }

    # 1. 走 HTTPS 的域名组（使用内部 CA 生成证书）
    *.l.s, admin.lab {
      tls internal
      reverse_proxy 127.0.0.1:8888
    }

    # 2. 仅走纯 HTTP 的通配符域名组（监听 80 端口）
    http://*.l.h {
      reverse_proxy 127.0.0.1:8888
    }

    # 貌似都不好使
    # :80 {
    #   @httpOnly host *.lab
      
    #   handle @httpOnly {
    #     reverse_proxy 127.0.0.1:8888
    #   }
    # }
    # http://*.lab {
    #   reverse_proxy 127.0.0.1:8888
    # }
  '';

  launchd.daemons.caddy = {
    script = "${pkgs.caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      # 核心修正：指定工作目录与环境变量，避免写根目录
      WorkingDirectory = "/var/lib/caddy";
      EnvironmentVariables = {
        HOME = "/var/lib/caddy";
        XDG_DATA_HOME = "/var/lib/caddy/data";
        XDG_CONFIG_HOME = "/var/lib/caddy/config";
      };
      StandardOutPath = "/var/log/caddy.log";
      StandardErrorPath = "/var/log/caddy.error.log";
    };
  };
}

# 应用 Nix 配置并启动 Caddy 后，运行以下命令将 Caddy 的根证书一次性导入 macOS 信任链
# sudo caddy trust
