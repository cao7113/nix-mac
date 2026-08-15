# Dnsmasq Vs. CoreDNS

在个人 macOS 开发机（配合 Nix / nix-darwin / sing-box TUN 模式）的场景下，对比 **dnsmasq** 与 **CoreDNS**，可以从产生背景、技术架构以及易用性三个维度进行深度剖析：

---

### 一、 产生背景

* **Dnsmasq**
* **背景**：诞生于 2000 年代初，旨在为小型局域网（如家庭网络、办公室）提供轻量级的 DNS 缓存和 DHCP 服务。
* **设计哲学**：小巧、零配置、极低资源占用，专注于做好一件事：把局域网和本地开发的名字解析搞定。


* **CoreDNS**
* **背景**：诞生于云原生和 Kubernetes 时代（由 Caddy 的作者 Miek Gieben 主导），是 CNCF 的毕业项目。它是为了替代旧有的 SkyDNS，成为 Kubernetes 集群默认的内网 DNS 核心。
* **设计哲学**：一切皆插件（Everything is a plugin）。通过灵活组合不同的插件，能够处理从简单的静态解析到复杂的云原生服务发现、gRPC 转发、甚至 Prometheus 监控指标暴露出各种需求。



---

### 二、 技术架构

* **Dnsmasq**
* **架构**：单体 C 语言编写。内部集成了 DNS 转发、DHCP、TFTP 等功能。它的数据源主要来自于本地的 `/etc/hosts` 文件以及上游 DNS。
* **特点**：极简。没有复杂的管道和中间件，内存占用通常只有几兆。


* **CoreDNS**
* **架构**：Go 语言编写。核心极其微小，所有的核心功能（如缓存、hosts 文件读取、TLS 转发、错误日志等）全部都是**插件（Plugins）**。通过一个类似 Caddyfile 的 `Corefile` 进行链式调用配置。
* **特点**：高度可扩展。你可以像搭积木一样，让一个请求先过缓存插件，再过 hosts 插件，最后丢给上游 DoH/DoT。



---

### 三、 易用性（针对个人 Mac + Nix 场景）

#### 1. 配置直观度

* **Dnsmasq**：配置文件极其平铺直叙。比如实现你的需求（`*.lab` 指向 `127.0.0.1`），在 nix-darwin 里只需要几行属性集就搞定了：
```nix
services.dnsmasq = {
  enable = true;
  addresses = {
    ".lab" = "127.0.0.1";
    ".localhost" = "127.0.0.1";
  };
};

```


* **CoreDNS**：功能虽然强大，但对于单机本地开发来说有点“大炮轰蚊子”。它的 `Corefile` 语法需要显式声明插件链。例如要实现类似功能，需要写：
```text
.lab:53 {
    hosts {
        fallthrough
    }
    forward . 1.1.1.1
    cache 30
}

```


在 nix-darwin 中，由于官方没有像 `services.dnsmasq` 那样开箱即用的高级封装模块，通常需要通过 `services.coredns.config` 手动拼接字符串文本，配置成本更高。

#### 2. 资源消耗与稳定性

* **Dnsmasq**：用 C 语言写就，在 macOS 上启动后几乎不消耗 CPU，内存占用稳定在 2MB-5MB 左右，非常适合作为个人笔记本的常驻后台。
* **CoreDNS**：Go 语言编写，自带 GC（垃圾回收），内存占用通常在 20MB-50MB 左右。虽然对现代 Mac 来说这点内存不算什么，但比起 Dnsmasq 还是略重了一点。

---

### 四、 最终结论：你应该选哪个？

对于**个人 macOS 电脑 + Nix 声明式开发环境**：

👉 **毫无疑问应该选 Dnsmasq。**

* **为什么？**
你的诉求非常明确且单一：**需要一个极其省心、稳定、完美支持 `.lab` 和 `.localhost` 泛解析的本地 DNS，并且要能跟 macOS 的 `/etc/resolver` 以及 sing-box 和平共处。**
Dnsmasq 完美契合这种“工具属性”，配置短小精悍，通过 nix-darwin 可以做到真正的“配置即即所得”。
* **什么时候选 CoreDNS？**
如果你未来有极其复杂的定制需求——比如希望把本地 DNS 请求通过 gRPC 转发到某个远程集群、或者需要用 Lua 脚本动态篡改本地 DNS 响应、又或者你在深度学习云原生架构并希望在本地完全模拟 K8s 的 DNS 行为，那才轮到 CoreDNS 登场。对于日常本地 Web 开发（如 Phoenix 项目按需唤醒），CoreDNS 属于过度设计。