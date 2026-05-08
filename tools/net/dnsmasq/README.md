# dnsmasq lab

## Caveats

To start dnsmasq now and restart at startup:
  sudo brew services start dnsmasq
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/dnsmasq/sbin/dnsmasq --keep-in-foreground -C /opt/homebrew/etc/dnsmasq.conf -7 /opt/homebrew/etc/dnsmasq.d,\*.conf
