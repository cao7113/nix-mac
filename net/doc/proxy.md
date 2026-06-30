# 基于虚拟网卡的全局代理

国内直连、国外代理、广告拦截

## Sing-box

- https://sing-box.sagernet.org/
- https://github.com/SagerNet/sing-box
- Golang

## Tailscale

- 基于 WireGuard® 协议的现代虚拟网状网络（Mesh VPN）工具
- P2P（点对点）架构
- 可以将你所有的设备（Mac、手机、云服务器、家里 NAS）安全地连接在同一个虚拟局域网（内网）中
- 天才之处在于它把“控制流”和“数据流”完全分离了
- 需要海外节点部署tailscale并声明为Exit node
- 本地安装客户端并使用海外Exit node
- 100%全局代理
- 开源版本headscale
- 问题：
  - 缺乏国内流量“直连绕过”机制（体验笨重）
  - 没有任何混淆防封锁设计，底层标准WireGuard 协议的特征极易被识别（导致断流，表现为频繁断流、丢包率飙升）

```
[ 本地 macOS ] (开启 Exit Node)
      │
      ▼ (整机 100% 流量被 WireGuard 捕获并加密)
[ 运营商/公网网络 ] (P2P 直连隧道)
      │
      ▼ (数据包到达)
[ 海外服务器 (如 Fly.io) ] (Tailscale Exit Node)
      │
      ▼ (在海外解密并 NAT 转发)
[ 自由互联网 (GitHub, OpenAI, Google) ]
```

### Tailscale 的部署架构

Tailscale 的天才之处在于它把“控制流”和“数据流”完全分离了：

控制平面（Coordination Server / Central DERP）：
由 Tailscale 官方维护（开源替代品叫 Headscale）。
它不接触你的任何隐私数据流量。它的唯一作用是帮助你的设备进行身份认证、交换公钥，并计算出两台设备之间最短的连接路径。

数据平面（Data Plane / P2P Tunnel）：
一旦官方的控制服务器帮你的 Mac 和远端服务器“牵线搭桥”成功，两台设备就会直接建立一条 WireGuard 加密隧道。
随后的所有数据传输都是点对点（P2P）直接对流，速度取决于你两端网络的物理带宽，不经过 Tailscale 公司的服务器。

### 实现100%代理的秘诀：系统路由表拦截

在 macOS 上，当你启动 Tailscale 时，它会调用苹果官方的 NetworkExtension 框架。
操作系统内核中会立刻创建一个名为 utun（如 utun3 或 utun7）的 三层虚拟网络接口（TUN 设备）。

流量进入 utun 虚拟网卡后，就来到了 Tailscale 的核心控制区。这里的架构设计非常高级，叫做 用户态网络栈（User-space Network Stack）。
接管： Tailscale 在本地后台运行着一个守护进程（tailscaled），它直接绑定了刚才创建的虚拟网卡。
剥离： 当流量从虚拟网卡灌进来时，它拿到的是最原始的 IP 数据包（Network Packets）。
用户态协议栈（gVisor / Netstack）： 传统工具需要依赖操作系统的内核去解析这些数据包，而 Tailscale 在自己的程序内部塞进了一个“精简版操作系统网络栈”（通常基于谷歌开源的 gVisor netstack）。它在用户态直接把这些 IP 数据包重组、加密，并封装进 WireGuard 协议。
物理发出： 封装好后，Tailscale 会通过一个特例通道（绕过刚才那两条拦截规则），利用你 Mac 真正的 Wi-Fi 物理网卡，把加密后的 UDP 数据包跨海发送给你的 Exit Node 节点。

仅仅创建网卡是不够的。当你开启 Exit Node（出口节点） 时，Tailscale 并不是去和某一个 App 谈判，而是直接对操作系统的内核路由表（Routing Table）进行了“降维打击”。
以 macOS 为例，Tailscale 会向系统内核写入最高优先级的两条路由规则：
0.0.0.0/1 via 100.x.x.x (指向 Tailscale 虚拟网卡)
128.0.0.0/1 via 100.x.x.x (指向 Tailscale 虚拟网卡)

传统的本地真实网卡（如你的 Wi-Fi），其默认网关是 0.0.0.0/0（掩码长度为 0）
根据最长前缀匹配原则，1 大于 0，因此操作系统内核在处理任何网络请求时，都会无条件优先选择 Tailscale 的虚拟网卡。


## Clash Verge Rev 或 Mihomo Party 

- 支持虚拟网卡 TUN 模式