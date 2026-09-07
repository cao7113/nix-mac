{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    caddy
  ];

  # NOTE: restart caddy service after change this config!!!
  # /etc/caddy/Caddyfile 配置 Caddy 监听 80/443 并反向代理到
  environment.etc."caddy/Caddyfile".source = ./Caddyfile;

  # 1. 确保创建保存证书的持久化目录
  system.activationScripts.postActivation.text = ''
    mkdir -p /var/lib/caddy
  '';

  launchd.daemons.caddy = {
    script = "${pkgs.caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
    serviceConfig = {
      WorkingDirectory = "/var/lib/caddy";
      # https://caddyserver.com/docs/conventions#file-locations
      EnvironmentVariables = {
        HOME = "/var/lib/caddy";
        # If the XDG_DATA_HOME environment variable is set, it is $XDG_DATA_HOME/caddy
        # macOS	$HOME/Library/Application Support/Caddy
        XDG_DATA_HOME = "/var/lib/caddy/data";
        # If the XDG_CONFIG_HOME environment variable is set, it is $XDG_CONFIG_HOME/caddy.
        # macOS	$HOME/Library/Application Support/Caddy
        XDG_CONFIG_HOME = "/var/lib/caddy/config";
      };
      StandardOutPath = "/var/log/caddy.log";
      StandardErrorPath = "/var/log/caddy.error.log";

      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
