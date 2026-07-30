# User and permission

这两个命令的核心区别在于：**`su - postgres` 会加载全新的环境变量和用户环境，而 `su postgres` 只切换用户身份，但保留你当前的非 postgres 环境变量。**

在运维 PostgreSQL（以及 Linux 系统管理）时，**强烈建议使用 `su - postgres**`。

---

### 核心区别对比

| 对比项 | `su postgres` | `su - postgres` (或 `su -l postgres`) |
| --- | --- | --- |
| **切换模式** | 非 Login Shell | **Login Shell（完全登录模式）** |
| **环境变量** | **保留**当前用户的环境变量（如原用户的 `PATH`、`PWD` 等） | **清除**原环境变量，**重新加载** `postgres` 的配置文件 |
| **工作目录 (`PWD`)** | 停留在你执行命令时的原目录 | 自动切换到 `postgres` 的家目录（如 `/var/lib/postgresql`） |
| **`$PATH` 路径** | 原用户的 `$PATH` | 加载 `postgres` 专属的 `$PATH`（包含 `psql`, `pg_ctl` 等命令路径） |

---

### 为什么运维 PostgreSQL 必须用 `su - postgres`？

如果你用 `su postgres`（少了一个 `-`）：

1. **找不到 PG 命令**：你直接输入 `psql` 或 `pg_ctl` 时，系统可能会报 `command not found`。因为 `postgres` 专属的安装路径（比如 `/usr/lib/postgresql/17/bin`）没有被装载到当前的 `$PATH` 里。
2. **配置文件或环境变量错乱**：如果 `postgres` 用户在 `.bashrc` 或 `.bash_profile` 里定义了 `PGDATA`（数据目录路径）或 `PGPORT`，`su postgres` 是**不会**加载这些变量的，这会导致 `pg_ctl status` 找不到数据库目录。

---

### 两者的联系

1. **目的相同**：两者都是 Linux 里的切换用户命令（Switch User），最终都会把当前 Shell 的执行权限切换为 `postgres` 用户。
2. **权限相同**：切换成功后，对文件和进程的读写权限完全一致（都是 `postgres` 权限）。
3. **都需要密码 / root 权限**：如果当前是 `root` 用户，执行这两个命令都不需要输密码；如果是普通用户，都需要输入目标/自身密码。

> **快捷记忆：**
> 带 `-` 表示“干净利落地像重新登录一次一样切换”；不带 `-` 表示“穿着原来的鞋子换个名字”。管理数据库时，**永远加上 `-**`！