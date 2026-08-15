{ config, pkgs, ... }: {
  # 1. 声明式配置并启用 dnsmasq
  services.dnsmasq = {
    enable = true;
    # 绑定在标准的 53 端口（如果没有被其他程序占用，直接跑在 53 性能最好）
    # 如果 53 端口被系统的 mDNSResponder 偶尔冲突，也可以绑定 127.0.0.1:53
    addresses = {
      ".lab" = "127.0.0.1";
      ".lh" = "127.0.0.1";
    };
  };

  # 2. 自动注入 macOS 的 resolver 机制，让系统原生识别 .lab
  system.activationScripts.extraActivation.text = ''
    if [ ! -d /etc/resolver ]; then
      sudo mkdir -p /etc/resolver
    fi

    # 将所有 .lab 域名的查询精准导向本地 dnsmasq
    if ! grep -q "127.0.0.1" /etc/resolver/lab 2>/dev/null; then
      echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/lab > /dev/null
    fi

    # 将所有 .lh 域名的查询精准导向本地 dnsmasq
    if ! grep -q "127.0.0.1" /etc/resolver/lh 2>/dev/null; then
      echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/lh > /dev/null
    fi
  '';
}
