# Forward port-80 to 8888


`/etc/pf.conf`
`man pf.conf`

## Try

```
## Setup
cat << 'EOF' > /tmp/pf_test.conf
rdr pass on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
EOF

# 1. 启用 pf 防火墙（如果尚未开启）
sudo pfctl -e
# 2. 加载 NAT/rdr 重定向规则
sudo pfctl -f /tmp/pf_test.conf

## Check
sudo pfctl -s nat
# rdr pass on lo0 inet proto tcp from any to any port = 80 -> 127.0.0.1 port 8888
sudo pfctl -s info

## Teardown
# 清空当前的 NAT / rdr 规则
sudo pfctl -F nat

# 如果想完全关闭 PF 防火墙
sudo pfctl -d
```