特性,Nix,Lix,Snix
主要语言,C++,C++ (正转向 Rust),Rust
主要目标,稳定性与兼容性,性能、DX（开发者体验）,模块化、Rust 原生重构
兼容性,基准,100% 兼容 Nix,目标兼容，目前部分实现
治理模式,基金会主导,社区共识驱动,独立开发者/研究驱动

以下是 Nix、Lix 和 Snix 的官方 GitHub 仓库地址及其主要技术背景的汇总。

值得注意的是，**Lix** 和 **Snix** 都是近期由于不同目的从 Nix 生态中衍生出来的项目，反映了社区在代码治理和技术选型（如 Rust 替代 C++）上的新趋势。

### 1. Nix (正统上游 / 原版)

这是所有 NixOS 生态的核心仓库。

- **GitHub 地址：** [github.com/NixOS/nix](https://github.com/NixOS/nix)
- **开始年份：** 2003年 (Eelco Dolstra 博士课题)
- **技术背景：** 主要由 **C++** 编写。它是目前最稳定、用户量最大的版本。

### 2. Lix (社区驱动的现代化分叉)

为了解决 Nix 官方治理僵化和重构缓慢问题而成立的 Fork。

- **GitHub 地址：** [github.com/lix-project/lix](https://github.com/lix-project/lix)
- **官方 Git 站点：** [git.lix.systems/lix-project/lix](https://git.lix.systems/lix-project/lix)
- **开始年份：** 2024年
- **技术背景：** 初始基于 Nix 的 C++ 代码，但已引入 **Meson** 构建系统，并正在积极使用 **Rust** 进行核心组件重写，重点在于性能优化和更好的报错信息。

### 3. Snix (Rust 原生重构版)

Snix 是一个旨在用 Rust 彻底重现 Nix 功能的实验性、模块化项目。

- **GitHub 地址：** [github.com/snix-project/snix](https://www.google.com/search?q=https://github.com/snix-project/snix) (或 [github.com/cachix/snix](https://github.com/cachix/snix) 镜像)
- **官方 Git 站点：** [git.snix.dev/snix/snix](https://git.snix.dev/snix/snix)
- **开始年份：** 2023年末 - 2024年初
- **技术背景：** **完全使用 Rust 编写**。它追求极高的模块化（如 `snix-eval`, `snix-store` 可独立使用），并支持在浏览器（WASM）和云端高性能运行。

---

### 项目横向对比

| 项目     | GitHub 流行度 (Stars) | 开发语言   | 核心卖点                       |
| -------- | --------------------- | ---------- | ------------------------------ |
| **Nix**  | ~16.5k                | C++, Shell | 行业标准，生态最全             |
| **Lix**  | ~0.6k (快速增长中)    | C++, Rust  | 性能优化，更好的开发者体验     |
| **Snix** | ~0.1k                 | Rust       | 彻底的模块化，高性能 Rust 实现 |

---

**你想深入了解如何将现有的 NixOS 配置迁移到 Lix，还是想了解 Snix 在性能上对比 C++ Nix 的具体基准测试数据？**
