{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    caddy
  ];

  # 1. 确保创建保存证书的持久化目录
  system.activationScripts.postActivation.text = ''
    mkdir -p /var/lib/caddy
  '';

  # NOTE: restart caddy service after change this config!!!
  # /etc/caddy/Caddyfile 配置 Caddy 监听 80/443 并反向代理到
  environment.etc."caddy/Caddyfile".text = ''
    {
        # 全局 PKI：定义本地 Root CA，启动时自动生成根证书，导入 Keychain 即可信任
        pki {
            ca local {
                # Caddy Local Authority"
                name "Caddy Local CA"
            }
        }

        # 按需 TLS：TLS 握手时实时向 ask 接口请求授权，收到 200 OK 才签发证书
        on_demand_tls {
            ask http://127.0.0.1:9111
        }
    }

    # 内部鉴权放行接口：显式指定 http:// 避免触发 Auto-HTTPS，无条件返回 200 给 Caddy 放行
    http://127.0.0.1:9111 {
        respond 200
    }

    # .s 域名：走 443 端口，由本地 CA 为具体单域名按需签发证书，解决通配符 *.s 被浏览器拒绝的问题
    *.s, *.*.s {
        tls {
            issuer internal
            on_demand
        }

        reverse_proxy localhost:8888
    }

    # .l 域名：显式指定 http:// 禁用 Auto-HTTPS 重定向，只走 80 端口明文代理，不触发 TLS 握手
    http://*.l, http://*.*.l {
        reverse_proxy localhost:8888
    }
  '';

  launchd.daemons.caddy = {
    script = "${pkgs.caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
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
