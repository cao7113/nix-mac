### 一、设置 `extra-substituters` 时，会自动排到前面吗？

**不会，Nix 默认不会自动把它排到前面，两者的优先级权重默认是完全平级的。**

在底层的处理机制中，`extra-substituters` 的作用仅仅是将你指定的 URL **追加（Append）** 到系统的默认源列表里。此时，它和官方的 `cache.nixos.org` 会拥有相同的默认优先级权重（通常权重值均为 `40`）。

当多源平级时，Nix 会**并发或随机**去探测这些源。为了确保国内镜像源**绝对优先**被访问，最稳妥、最规范的写法是利用 `?priority=` 参数显式声明优先级。

> 💡 **Nix 优先级规则：** 数字越小，优先级越高（例如 `10` 优于 `40`）。

#### 🎯 完美推荐的主流写法：

```nix
extra-substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10

```

加上 `?priority=10` 后，Nix 会铁定优先去清华源查找，找不到时才会落到默认权重为 `40` 的官方源上，完美兼顾了速度与容灾。

---

### 二、国内顶级 Nix Substituters 镜像排名

Nix 的二进制缓存体量极其恐怖（数百 TB 级别），国内只有极少数顶级高校和机构有能力提供完整的 `store` 镜像服务。以下是综合 **速度、同步稳定性、带宽以及社区流行度** 后的最新专业排名：

#### 🥇 第一名：清华大学 TUNA 镜像站

* **地址：** `[https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store](https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store)`
* **评级：** 🌟🌟🌟🌟🌟（无可争议的国内王者）
* **特点：** 国内最早支持 Nix 完整 Store 镜像的站点，也是目前社区最活跃、最主流的默认选择。教育网骨干带宽极大，公网访问也非常稳定，同步频率高。

#### 🥈 第二名：中国科学技术大学 USTC 镜像站

* **地址：** `[https://mirrors.ustc.edu.cn/nix-channels/store](https://mirrors.ustc.edu.cn/nix-channels/store)`
* **评级：** 🌟🌟🌟🌟✨
* **特点：** 老牌开源镜像站，同步策略非常激进。当清华源因为磁盘或硬件维护出现故障时，中科大源永远是最可靠的完美替代者，速度与清华源在伯仲之间。

#### 🥉 第三名：上海交通大学 SJTUG 镜像站

* **地址：** `[https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store](https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store)`
* **评级：** 🌟🌟🌟🌟
* **特点：** 华东地区用户的福音，网络节点质量极高。上交大镜像站在特定网络（如电信、联通部分直连线路）下的单线程下载速度甚至经常能超越清华。

#### 🏅 聚合推荐：CERNET（中国教育和科研计算机网）联合镜像源

* **地址：** `[https://mirrors.cernet.edu.cn/nix-channels/store](https://mirrors.cernet.edu.cn/nix-channels/store)`
* **评级：** 🌟🌟🌟🌟
* **特点：** 由多校联合维护的顶级路由节点，它会自动根据你当前所在的网络，将流量智能调度到最快的教育网镜像节点（通常会在清华/交大间切换）。

---

### ⚠️ macOS / `nix-darwin` 用户的一点核心提示

绝大多数国内镜像站（包括清华、中科大等）由于磁盘容量和上游同步限制，它们同步的**基本上只有 NixOS（Linux）的官方 Channel 二进制缓存**。

如果你是在 macOS 下使用 `nix-darwin`：

1. **基础包（如 CLI 工具、底层依赖）：** 镜像站是完全通用的，能帮你极大地加速核心底层组件的下载。
2. **macOS 专有包（针对 Darwin 架构编译的上层 GUI 应用或特定软件）：** 国内镜像站很大可能没有命中（返回 404）。

因此，作为 macOS 用户，你**千万不能**直接用 `substituters = ...` 抹除官方源。必须按照前面的方法，使用 `extra-substituters` 配合 `?priority=10`，让国内源去加速基础依赖，让官方源去兜底 Darwin 特有的二进制包，这才是真正长治久安的黄金配置。