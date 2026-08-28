# Pflog0

这是因为在 macOS 上，`pflog0` 虚拟接口**默认是不存在的**，且 macOS 的内核 PF 模块默认并没有创建/加载 `pflog` 设备。

如果你需要监听 PF 的日志，需要先手动创建 `pflog0` 接口：

### 1. 手动创建并启用 `pflog0` 接口

运行以下命令创建接口并将其拉起（Up 状态）：

```bash
# 1. 创建虚拟网络接口 pflog0
sudo ifconfig pflog0 create

# 2. 启用该接口
sudo ifconfig pflog0 up

```

---

### 2. 在 PF 规则中添加 `log` 关键字

PF 只会捕获明确带有 `log` 标记的规则流量。例如，修改你的 `com.user.port80.pf.conf`：

```text
rdr pass log on lo0 inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080

```

加载更新后的规则：

```bash
sudo pfctl -f /etc/pf.anchors/com.user.port80.pf.conf

```

---

### 3. 重新运行抓包

接口创建并启用后，再运行 `tcpdump` 即可正常监听：

```bash
sudo tcpdump -n -i pflog0

```

---

### 4. 测试完成后清理接口

测试完毕后，如果不再需要监听日志，可以销毁该虚拟接口：

```bash
sudo ifconfig pflog0 destroy

```