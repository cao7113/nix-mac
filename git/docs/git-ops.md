# GitOps

**GitOps** 是一种持续交付（CD）和基础设施自动化的**云原生运维范式**。

它的核心理念极其简单：**将 Git 仓库作为系统的“唯一事实来源”（Single Source of Truth）**。你不再手动运行命令去配置服务器，而是将基础设施和应用程序的所有期望状态（Desired State）以“代码”的形式写进 Git 仓库里，系统通过自动化工具（如 ArgoCD、Flux）自动将真实的运行环境拉取并同步为 Git 里的状态。

---

### 核心运作原理与对比

传统运维（Push 模式）与 GitOps（Pull 模式）在工作流上有本质区别：

| 维度 | 传统 CI/CD (Push 模式) | GitOps (Pull 模式) |
| --- | --- | --- |
| **执行者** | Jenkins / GitHub Actions 等外部 CI 系统 | 部署在集群内部的 GitOps Agent（如 ArgoCD） |
| **触发机制** | CI 脚本拿着最高权限，向集群**推送（Push）**部署指令 | Agent 轮询 Git 仓库，发现差异后在集群内**拉取（Pull）**并同步 |
| **安全隐患** | CI 系统必须保存目标集群的最高管理凭证（如 Kubeconfig） | 集群凭证无需泄露给外部 CI 系统，安全边界收敛在集群内部 |
| **配置漂移** | 容易发生（有人私下用 `kubectl edit` 修改集群后，CI 无法感知） | 彻底消除（Agent 会检测到私下修改并强制还原为 Git 上的配置） |

---

### GitOps 的四大核心原则

根据 Cloud Native Computing Foundation (CNCF) 的规范定义，GitOps 必须满足以下 4 个原则：

1. **声明式（Declarative）**：系统必须通过声明式代码描述（例如 Kubernetes 的 YAML 规范），说明“我要什么状态”，而不是写指令式脚本（如 Shell）说明“如何去一步步做”。
2. **版本化与版本控制（Versioned and Stored in Git）**：所有配置（基础设施、应用、网络策略等）都存储在 Git 中，具备完整的变更历史、审计日志和追溯能力。
3. **自动拉取与应用（Automated Approval & Pull）**：一旦 Git 中的声明发生变更（例如合并了一个 Pull Request），自动化 Agent 能够自动将变更应用到集群中。
4. **持续纠偏与自愈（Continuous Reconciliation）**：Agent 持续监控实际状态与 Git 目标状态。如果发生偏差（由于意外崩溃或人为篡改），系统会自动纠正以恢复一致。

---

### 典型工作流程（以 Kubernetes 为例）

1. **提交变更**：开发者将应用程序代码提交到 Git 仓库，触发 CI 流程编译 Docker 镜像并推送到镜像仓库。
2. **修改配置**：CI 完成后，自动提交一个 Commit 更改配置仓库（Manifest Repo）中的 YAML 文件（例如更新镜像 Tag 版本为 `v1.2.0`）。
3. **发起审查**：开发者提交一个 **Pull Request (PR)**，团队成员进行 Code Review，审核通过后合并至 `main` 分支。
4. **自动同步**：运行在 K8s 集群内部的 ArgoCD/Flux 检测到 `main` 分支有更新，立即将新的 YAML 部署到集群中。
5. **回滚处理**：如果发现新版本有 Bug，只需在 Git 上执行 `git revert`，集群就会自动退回到上一个稳定版本。

---

### GitOps 的核心优势

* **简单快速的回滚**：生产环境故障时，无需重新运行复杂的流水线，只需在 Git 仓库一键 `git revert` 即可在几秒内恢复集群。
* **更高的安全性**：避免了将 Kubernetes 的管理员 Token/Certificate 裸露给第三方 CI 工具，降低攻击面。
* **极高的透明度与审计能力**：谁在什么时间修改了哪个配置、为什么修改（结合 PR 讨论），都有不可篡改的 Git Commit Log 作为凭证。
* **灾难恢复（Disaster Recovery）极快**：如果整个 K8s 集群意外瘫痪，只需创建一个新的空集群并指向同一个 Git 仓库，GitOps Agent 就能在极短时间内重建所有业务。