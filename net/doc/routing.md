# 路由表

默认网关 0.0.0.0/0、0.0.0.0/1 以及 Tailscale 注入的各种规则，属于路由表（Routing Table）。
在 macOS 上，你必须使用以下命令才能看到它们：

```Bash
netstat -nr
```