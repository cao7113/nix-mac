# Caddy

实现 HTTPS，并自动信任本地 TLS 证书


```
# nix installed curl
export SSL_CERT_FILE="$HOME/Library/Application Support/Caddy/pki/authorities/local/root.crt"
curl  https://foo.a.lab

# macos /usr/bin/curl


```

## Trust

```
❯ sudo caddy trust
2026/08/24 14:27:36.920 WARN    installing root certificate (you might be prompted for password)        {"path": "localhost:2019/pki/ca/local"}
2026/08/24 14:27:36.953 INFO    warning: "certutil" is not available, install "certutil" with "brew install nss" and try again
2026/08/24 14:27:36.953 INFO    define JAVA_HOME environment variable to use the Java trust
2026/08/24 14:27:52.515 INFO    certificate installed properly in macOS keychain

sudo caddy untrust
```

## Admin

2019（Caddy 的 Admin API 管理端口）

sudo caddy trust 需要连接本地运行中的 Caddy Admin API 来获取内置 CA 证书并注入 macOS 的 Keychain（系统钥匙串）。

pgrep -l caddy
curl http://localhost:2019/pki/ca/local