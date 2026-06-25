# Network Benchmarking

https://gemini.google.com/app/0bfc94309c599d28

- https://speed.cloudflare.com/
- https://fast.com/
https://www.speedtest.net/
Ookla Speedtest CLI (官方原生版)
https://www.speedtest.net/apps/cli
Speedtest by Ookla (全平台 App)

Speedtest-Tracker(基于Speedtest CLI)
https://github.com/alexjustesen/speedtest-tracker
PingPlotter

https://test.ustc.edu.cn/
https://www.speedtest.cn/

## CLI


speedtest cli
librespeed cli
https://github.com/librespeed/speedtest-cli
https://github.com/showwin/speedtest-go


在网络基准测试（Network Benchmarking）这个领域，**Ookla 旗下的 Speedtest** 是毫无疑问的**武林盟主**。无论是在大众认知度、商业变现，还是在行业标准的制定上，它都占据着绝对的统治地位。

不过，随着云计算、流媒体、5G 以及边缘计算的发展，市场上也涌现出了多位风格迥异的“绝顶高手”。以下是对 Speedtest 及其主要竞品的综合评估与江湖地位剖析：

---

## 一、 武林盟主：Speedtest by Ookla

* **核心优势**：**服务器网络无敌（全球上万个节点）**、算法成熟（能够精准过滤异常丢包和延迟）、跨平台支持极佳（Web、App、CLI、路由器嵌入）。
* **商业模式**：面向B端提供 Ookla 5G Map、数据分析报告（运营商买单）及企业级测速引擎授权；面向C端靠广告和高级功能变现。
* **江湖地位**：**绝对统治者。** 无论是运营商自查、数码博主评测，还是普通用户宽带升级，Speedtest 的结果就是**行业公认的“度量衡”**。

---

## 二、 八方群雄：主流竞品分析

### 1. Fast.com (Netflix 旗下) —— 纯粹的刺客

* **特点**：极简到了极致，打开网页直接开测，没有任何广告。
* **技术逻辑**：它的测速节点全部伪装成 Netflix 的流媒体服务器。
* **杀伤力**：专门用来测试**运营商是否对流媒体偷工减料（限速）**。如果 Speedtest 跑满，但 Fast.com 跑不动，说明运营商在玩“定向策略加速”。
* **江湖地位**：**流媒体时代的“照妖镜”。**

### 2. Cloudflare Speed Test —— 学院派大师

* **特点**：由全球最大的 CDN/网络安全厂商之一 Cloudflare 推出。
* **技术逻辑**：不单单测最大带宽，它会连续发送不同大小（25kB, 100kB, 1MB, 10MB...）的数据包，详细测试 **Loaded Latency（负载下延迟）** 和 **Jitter（抖动）**。
* **杀伤力**：极其精准地反映用户在实际浏览网页、玩游戏、视频会议时的真实网络质量，而非大文件下载的极限速度。
* **江湖地位**：**技术硬核派的首选。** 它的数据对开发者和网络工程师而言，比 Speedtest 更有参考价值。

### 3. Google Fiber Speedtest & 各种 ISP 自建测速 —— 地方豪强

* **特点**：大厂或当地运营商（如中国电信的“天翼测速”、中国联通测速）自建。
* **技术逻辑**：主要测试用户到当前运营商骨干网的距离和速度。
* **江湖地位**：**测堵塞与维权的“铁证”。** 当你和运营商客服对线投诉“宽带不达标”时，使用他们自家的测速结果通常最有效。

### 4. iPerf3 —— 隐世的扫地僧（命令行/局域网）

* **特点**：没有好看的 UI，纯命令行工具。
* **技术逻辑**：允许用户自己搭建服务端和客户端，进行点对点的网络吞吐量测试。
* **关键场景**：主要用于测试**局域网（LAN）内设备（如 NAS、路由器、交换机）的极限性能**，或者内网 Wi-Fi 的真实速率，排除外网干扰。
* **江湖地位**：**专业网络工程师和 PT/NAS 发烧友的“终极信仰”。**

---

## 三、 综合对比天梯榜

| 维度 | Speedtest (Ookla) | Fast.com | Cloudflare Test | iPerf3 |
| --- | --- | --- | --- | --- |
| **节点覆盖** | 👑 全球第一 (极多本地节点) | 依托 Netflix CDN | 依托 Cloudflare 边缘网 | 需用户自建/指定点 |
| **测速侧重点** | 物理极限带宽 (峰值) | 流媒体播放真实带宽 | 综合网络质量 (抖动/负载延迟) | 纯粹的链路吞吐量 |
| **广告干扰** | 较多 (App/Web 略显臃肿) | 🚫 无 | 🚫 无 | 🚫 无 |
| **自动化/CLI** | 支持 (官方有二进制 CLI) | 仅第三方封装 | 网页端自带详细图表 | 👑 原生命令行，支持脚本 |
| **适用人群** | 大众、运营商、数码评测 | 追剧党、检测限速 | 开发者、网络极客 | 运维、内网发烧友 |

---

## 四、 总结：江湖地位与未来演变

* **Speedtest 依然是“武林至尊”**：依靠先发优势、庞大的 B 端商业帝国以及全球运营商自愿贡献的测速节点，其垄断地位在短期内**完全不可动摇**。
* **竞品各据一方**：
* 如果你想看**看剧卡不卡**，去 **Fast.com**；
* 如果你想看**游戏卡不卡/网络稳不稳**，去 **Cloudflare**；
* 如果你在调试**家里的软路由或 NAS 吞吐**，老老实实上 **iPerf3**。



对于高级用户（如开发者或系统管理员）而言，Speedtest 官方提供的 **CLI 工具** 依然是写自动化脚本时获取外网带宽最稳定的选择，但 Cloudflare 正在凭借其在全球网络边缘侧的庞大流量优势，不断蚕食专业用户对 Ookla 的信任。