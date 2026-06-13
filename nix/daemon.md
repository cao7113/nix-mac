# Nix daemon

Daemon的工作原理，特别是下载package时的网络环境，如何配置走代理等

!!!

两层结构 提示

nix-daemon plist中配置proxy

nix 执行命令时也开启 proxy

由于 Nix 底层使用 libcurl 库来进行实际的 HTTP/S 请求，因此 Nix 的代理逻辑实际上是交由 libcurl 去解析和执行的，但其暴露、隔离和传递方式受到了 Nix 沙箱（Sandbox）和守护进程（Daemon）机制的严格限制。

https://github.com/NixOS/nix/blob/master/src/libstore/filetransfer.cc


在 Nix 中，**普通编译（Derivation）在沙箱内运行，是完全没有网络访问权限的**。但有一些 Derivation 用来下载源码（如 `fetchgit`、`fetchurl` 等），它们声明了输出结果的哈希值（`sha256`），这被称为 **Fixed-Output Derivations (FOD)**。

* **为什么配置了 `nix.conf` 代理，FOD 还是下载失败？**
  因为 `fetchgit` 或 `fetchurl` 作为 Nixpkgs 的 Derivation 运行时，其底层依然是在沙箱中 fork 出一个独立的进程来执行 `curl` 或 `git fetch`。**沙箱会裁剪掉所有的宿主机环境变量**，因此外界的 `http_proxy` 根本传不进沙箱。
* **Nix 的特殊代理放行机制**：
  为了解决上述问题，Nix 允许在 `/etc/nix/nix.conf` 中显式地声明这些环境变量为“可信任且需要传入沙箱”的。
  
  Nix 核心配置解析器（`src/libstore/globals.cc`）中定义了许多配置项：
  * **`impure-env`**：控制允许带入沙箱的环境变量列表。
  
  为了让沙箱内的 `fetch*` 函数感知到代理，通常需要在 `/etc/nix/nix.conf` 中进行如下声明：
  ```text
  # 显式允许将代理变量带入沙箱环境
  impure-env = http_proxy https_proxy no_proxy ftp_proxy all_proxy


Nix 本身不实现网络协议，它完全信任并依赖 libcurl。针对 Proxy：

纯 Nix 动作 (Flakes/Substituter)：由 nix-daemon 直接调用 libcurl 运行。代理成败取决于 nix-daemon 进程本身有没有拿到系统代理环境变量。

Nixpkgs 里的 Fetcher (FOD 阶段)：在沙箱中运行，必须配置 Nix 的 impure-env 允许代理变量穿透沙箱，内部的下载命令（如 git 或 curl）才能正常通过代理联网。

如何开启沙箱，相关沙箱工作机制

man nix.conf

nix-daemon会加载 ~/.config/nix/nix.conf 吗
不会，只会加载/etc/nix/nix.conf

但这并不意味着写在 ~/.config/nix/nix.conf 里的配置完全无效。Nix 内部采用了一种 Client-Daemon（客户端-服务端）配置传递机制，而这正是导致很多用户侧配置（特别是镜像源/Substituter 替换）频繁失效的根源。

配置的生命周期与传递机制
当作为一个普通用户在终端执行类似 nix profile add、nix flake clone 或 nix build 时，整个配置的加载和鉴权流程如下：

Client 侧加载：运行的 nix 命令（客户端进程）在当前用户上下文中启动，它会首先读取当前用户的 ~/.config/nix/nix.conf。

通过 Socket 传递：客户端进程通过 Unix Domain Socket 连上 nix-daemon，并将它刚刚从用户配置里读到的 Key-Value 键值对，作为请求上下文的一部分打包传递给 nix-daemon。

Daemon 侧审查：nix-daemon 收到这些配置后，并不会盲目信任并应用，而是会结合自身的系统级配置进行严格的安全审计。