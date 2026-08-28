{ config, pkgs, ... }: {

  services.dnsmasq = {
    enable = true;

    addresses = {
      # demo.l.h
      ".h" = "127.0.0.1";
      # https support by caddy, demo.l.s
      ".s" = "127.0.0.1";
      # admin.lab
      ".lab" = "127.0.0.1";
    };
  };

  # ls -l /etc/resolver
  system.activationScripts.extraActivation.text = ''
    if [ ! -d /etc/resolver ]; then
      sudo mkdir -p /etc/resolver
    fi

    # 将所有 .h 域名的查询精准导向本地 dnsmasq
    if ! grep -q "127.0.0.1" /etc/resolver/h 2>/dev/null; then
      echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/h > /dev/null
    fi

    if ! grep -q "127.0.0.1" /etc/resolver/lab 2>/dev/null; then
      echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/lab > /dev/null
    fi

    # 将所有 .s 域名的查询精准导向本地 dnsmasq
    if ! grep -q "127.0.0.1" /etc/resolver/s 2>/dev/null; then
      echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/s > /dev/null
    fi
  '';
}
