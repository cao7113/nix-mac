# Cache and registry

面对 `nixpkgs` 这种 GB 级别的仓库，频繁下载或克隆确实很痛苦。要提升本地开发和调试 Flakes 的效率，核心思路是**减少重复下载**和**利用增量更新**。

以下是几种高效的优化方案：

---

### 1. 使用 Git 浅克隆 (Shallow Clone)

如果你只需要最新代码进行本地开发，不需要整个项目的提交历史，可以使用 `--depth 1`。这能将下载量从几 GB 缩减到几百 MB。

```bash
git clone --depth 1 -b nixos-24.11 https://github.com/NixOS/nixpkgs.git ~/dev/nixpkgs

```

- **优点**：速度极快。
- **用法**：在 `flake.nix` 中使用本地路径引用：

```nix
inputs.nixpkgs.url = "path:/home/user/dev/nixpkgs";

```

---

### 2. 固定 `flake.lock` 并利用 Nix 缓存

Nix 会将下载的 tarball 缓存在 `/nix/store` 中。只要你的 `flake.lock` 不变，Nix 就不会重新下载。

- **避免 `nix flake update**`：除非必要，否则不要运行它。
- **手动预下载**：如果你有多个项目共用一个版本，可以用 `nix-prefetch-url` 提前把 tarball 塞进 Store：

```bash
nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

```

---

### 3. 使用本地 Registry (最佳实践)

你可以告诉 Nix，当它看到 `nixpkgs` 这个引用时，直接指向你本地的一个目录，而不是去 GitHub 下载。

```bash
nix registry add nixpkgs ~/dev/nixpkgs

```

这样当你写 `inputs.nixpkgs.url = "nixpkgs";` 时，它会直接秒开本地目录。

---

### 4. 离线/内网环境：设置 Cache 代理

如果你在公司内部或网络环境极差，可以搭建一个 **Nix 缓存代理**（如 `Harmonia` 或 `Cachix` 的本地实例），或者使用简单的 HTTP 镜像。

- **替代 URL**：如果你有国内镜像源（如 TUNA/BFSU），在 Flake 中直接使用镜像地址：

```nix
inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
# 或者替换为国内维护的镜像存储

```

---

### 5. 调试技巧：使用 `nix repl`

调试 `nixpkgs` 里的函数或包时，不要每次都重新跑 `nix build`。

直接进入 REPL 并加载本地 nixpkgs：

```bash
nix repl -f ~/dev/nixpkgs

```

这样你可以即时测试修改后的 Nix 代码，无需等待下载或完整的构建循环。

---

### 总结建议

| 场景                          | 推荐方案                              |
| ----------------------------- | ------------------------------------- |
| **本地频繁修改 nixpkgs 代码** | **方案 1 + 方案 3** (本地路径引用)    |
| **多个项目共用同一版本**      | **方案 2** (锁定 lock 文件)           |
| **网络环境极差**              | **方案 1** (浅克隆一次，永久本地使用) |

**你需要我帮你写一个自动同步本地 nixpkgs 副本并关联到 Flake 的 Taskfile 脚本吗？**
