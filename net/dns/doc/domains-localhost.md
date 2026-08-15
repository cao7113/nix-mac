# `.local` 和 `.localhost` domain

在 macOS（以及现代类 Unix 系统）中，`.local` 和 `.localhost` 虽然看起来只差几个字母，且都常用于本地开发或局域网环境，但它们在**操作系统底层、网络标准、以及解析机制**上有着本质的区别。

以下是关于这两个顶级域名（TLD）在 macOS 上的深度解析原理：

---

### 一、 `.localhost`：标准环回域名（Loopback Domain）

`.localhost` 是一个**由 IETF 标准 RFC 6761 明确保留的特殊用途顶级域名**。

#### 1. 解析原理与底层机制

* **硬编码与零查询：**
现代操作系统（包括 macOS、Linux、Windows）的网络栈和浏览器在遇到任何以 `.localhost` 结尾的域名（如 `foo.localhost` 或 `somemissing.localhost`）时，**默认不会向任何 DNS 服务器（无论是本地的 53 端口、Dnsmasq 还是公网 DNS）发送任何 UDP/TCP 查询请求**。
* **直接映射：**
操作系统内部的网络解析库（如 macOS 的 `getaddrinfo`）会在本地直接将其解析为回环地址：
* IPv4：`127.0.0.1`
* IPv6：`::1`



#### 2. 在 macOS 上的表现

* 你无需在 `/etc/hosts` 中做任何配置，也无需任何 DNS 守护进程。
* 只要你访问 `*.localhost`，系统网卡协议栈直接在内存中完成闭环。
* **安全上下文：** 在主流浏览器（Chrome、Safari）中，`.localhost` 被隐式视为**安全上下文（Secure Context）**，这意味着即使不走 HTTPS 协议（使用纯 HTTP），浏览器也允许网页使用诸如 Service Worker、Geolocation 等高级 API。

---

### 二、 `.local`：多播 DNS（mDNS / Bonjour）专用域名

与 `.localhost` 纯粹代表“本机回环”不同，`.local` 是一个有着悠久历史和复杂背景的**多播 DNS（Multicast DNS, mDNS）专用顶级域名**，在 Apple 生态中通常被称为 **Bonjour**。

#### 1. 解析原理与底层机制

* **RFC 6762 标准：** `.local` 被保留用于零配置网络（Zeroconf）。这意味着任何以 `.local` 结尾的域名，**不是**由传统的单播 DNS 服务器（如 `1.1.1.1` 或你的路由器 DNS）解析的。
* **多播广播机制：**
当你在 macOS 中请求一个 `.local` 域名（例如 `my-macbook-pro.local` 或 `my-device.local`）时：
1. 系统会通过局域网的多播地址（IPv4: `224.0.0.251`，IPv6: `[ff02::fb]`）向整个本地局域网广播一个 mDNS 查询包（端口 `5353`）。
2. 局域网内拥有这个名字的设备（或者你的 Mac 自己）听到这个广播后，会通过多播直接应答它的 IP 地址。



#### 2. 在 macOS 上的特殊行为（系统守护进程 `mDNSResponder`）

* **苹果的核心服务：** macOS 内置了一个名为 `mDNSResponder` 的底层系统守护进程，它深度接管了所有 `.local` 流量。
* **为什么有时会变慢或超时？**
如果你尝试去 `ping` 一个不存在的 `.local` 域名（例如 `missing.local`），你会发现终端会卡顿一两秒才报错。这是因为 macOS 正在局域网里广播寻找这个设备，直到超时未收到任何设备的响应，它才会宣告解析失败。
* **本地开发踩坑点：**
正因为 `.local` 被苹果的 `mDNSResponder` 强行绑定用于局域网设备发现，**它极不适合用来做本地 Web 开发的泛域名（如 `*.local` 映射到 `127.0.0.1`）**。如果你强行把 `*.local` 指向本地回环，不仅会和 mDNS 发生严重的协议冲突，还会导致局域网设备互联、AirDrop、打印机发现等 Apple 核心服务出现异常延迟或紊乱。

---

### 三、 核心总结对比表

| 特性维度 | `.localhost` | `.local` |
| --- | --- | --- |
| **标准出处** | RFC 6761 (保留用于环回) | RFC 6762 (保留用于 mDNS / 零配置网络) |
| **解析行为** | **系统硬编码**，直接返回 `127.0.0.1` | **局域网多播广播**（mDNS / Bonjour） |
| **网络开销** | 零（纯内存映射，毫秒级响应） | 高（需向局域网发广播包，有超时机制） |
| **macOS 谁处理** | 操作系统网络栈底层 (`getaddrinfo`) | 系统守护进程 `mDNSResponder` |
| **适合用来做本地开发吗？** | **非常适合**（原生支持，安全且高效） | **极不适合**（会导致局域网多播冲突与卡顿） |