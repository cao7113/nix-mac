{ config, pkgs, ... }: {
  services.dnsmasq = {
    enable = true;

    addresses = {
      ".h" = "127.0.0.1";
      # work with caddy
      ".l" = "127.0.0.1";
      ".s" = "127.0.0.1";
    };
  };

  # 声明式自动生成 /etc/resolver/<tld>
  environment.etc = {
    "resolver/h".text = "nameserver 127.0.0.1\n";
    "resolver/l".text = "nameserver 127.0.0.1\n";
    "resolver/s".text = "nameserver 127.0.0.1\n";
  };
}
