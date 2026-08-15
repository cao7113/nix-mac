# DNS

- `*.local` mac mDNS多播域名
- `*.localhost` RFC支持的本地地址，无需dns解析，硬编码的
- `*.lab` 本地正式域名 dnsmasq配置
- `*.lh` 本地测试域名 dnsmasq配置

```
host qq.com
```

## todo

- 如何列出本地网络中可访问的所有 `*.local` 域名

```
dns-sd -B _services._dns-sd._udp
```