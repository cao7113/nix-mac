# Cname record

### 1. 什么是 CNAME？

**CNAME**（Canonical Name Record，别名记录）是 DNS 记录的一种类型。它的作用是将一个域名（别名）**指向另一个域名（规范域名/真实主域名）**，而不是直接指向具体的 IP 地址。

* **比喻**：假设 `livebook.s` 是一个人的身份证名字（主域名），`lv.s` 是他的外号（CNAME 别名）。DNS 看到 `lv.s` 时，会说：“`lv.s` 就是 `livebook.s`，你去查 `livebook.s` 的地址吧。”

---

### 2. CNAME 的工作原理与解析机制

当你访问 `https://lv.s` 时，DNS 解析的底层机制如下：

1. **发起请求**：浏览器向 DNS 服务器（你本地的 dnsmasq）询问：“`lv.s` 的 IP 地址是多少？”
2. **匹配 CNAME 规则**：dnsmasq 查到 `cname=lv.s,livebook.s`，发现这是一个 CNAME 别名。
3. **二次追溯 (A 记录)**：dnsmasq 接着去查找 `livebook.s` 的 IP 地址，发现 `address=/livebook.s/127.0.0.1`，得到 IP `127.0.0.1`。
4. **组合返回**：dnsmasq 在响应包（ANSWER SECTION）中同时返回两行结果：
* `lv.s -> CNAME -> livebook.s`
* `livebook.s -> A -> 127.0.0.1`


5. **发起连接**：浏览器拿到最终 IP `127.0.0.1`，向 `127.0.0.1:443` 发起 TCP 连接和 TLS 握手。

---

### 3. 在网关/反向代理（如 Gateway / Caddy / Nginx）中，会收到哪个 Host？

**答案是：网关接收到的 Host 头仍然是 `lv.s`，而不是 `livebook.s`。**

#### 为什么？

DNS 解析**只负责寻找 IP 地址**，它在 TCP 连接建立之前就完成了。

当浏览器解析出 `lv.s` 对应的 IP 是 `127.0.0.1` 后，它会向 `127.0.0.1` 发送 HTTP 请求。HTTP/HTTPS 协议规定，**请求头（HTTP Header）中的 `Host` 字段必须保留用户在地址栏输入的原始域名**。

整个传输过程如下：

```text
用户浏览器地址栏: https://lv.s
    │
    ├─► 1. DNS 解析: lv.s --(CNAME)--> livebook.s --(A)--> 127.0.0.1
    │
    └─► 2. HTTP/HTTPS 请求发送到 127.0.0.1:443
           请求报文内容：
           ┌─────────────────────────────┐
           │ GET / HTTP/1.1              │
           │ Host: lv.s                  │ <── 依然是原始输入的 lv.s！
           │ SNI (TLS 握手): lv.s         │
           └─────────────────────────────┘

```

#### 在网关（Gateway / Caddy）中意味着什么？

如果你在网关（如 Caddy / Nginx）中配置反向代理：

* **如果网关只配置了 `livebook.s**`：当访问 `https://lv.s` 时，网关收到的是 `Host: lv.s`，因为匹配不到规则，网关会返回 **404** 或 **421 Misdirected Request**（TLS SNI 不匹配）。
* **正确的网关配置方式**：你必须在网关中**同时声明这两个域名**，或者配置通配符/重定向。

以 Caddy 为例：

```caddyfile
# 方案 A：让两个域名响应相同的内容
livebook.s, lv.s {
    reverse_proxy 127.0.0.1:4000
}

# 方案 B：将 lv.s 301 重定向到 livebook.s
lv.s {
    redir https://livebook.s{uri}
}

livebook.s {
    reverse_proxy 127.0.0.1:4000
}

```