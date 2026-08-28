# Forward port-80 to 8888

sudo pfctl -d

```
man pf.conf
cat /etc/pf.conf

# 查看 PF 整体运行状态（开启/禁用、内存限制、计数器等）
sudo pfctl -s info

# 查看当前生效的所有过滤规则（Filter Rules）
sudo pfctl -v -s rules

# 查看当前生效的重定向/NAT 规则（rdr 规则）
sudo pfctl -s nat

# 查看 PF 处理数据包的实时统计指标（丢包数、匹配规则数等）
sudo pfctl -s All
```

## Log

如果需要抓取特定规则（如拦截规则 block 或重定向规则 rdr）的日志，规则中必须包含 log 关键字

```
# 示例：记录所有被 block 的数据包
block log all

# 示例：记录经过 lo0 重定向的 80 端口数据包
rdr pass log on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8888

# 实时打印被 PF 日志记录的数据包（简洁模式）
sudo tcpdump -n -i pflog0

# 打印详细报文头与 HEX 内容
sudo tcpdump -ne -vv -i pflog0

# 如果你只想看 80 或 8080 端口相关的拦截/重定向日志
sudo tcpdump -n -i pflog0 port 80 or port 8888
```

## Try in hand

```
## Setup
cat << 'EOF' > /tmp/pf_test.conf
rdr pass on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8888
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