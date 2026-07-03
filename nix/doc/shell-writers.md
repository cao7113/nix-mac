# Shell scripts

在 Nixpkgs 中，这类函数统称为 **Writers**（写入器）。它们的共同目标是：**将 Nix 字符串转换为 /nix/store 中的可执行文件**。

除了 `writeShellApplication`，最常用的还有以下几种，它们在依赖管理和校验机制上各有侧重：

---

### 1. `writeShellScriptBin`

这是最基础的 Shell 脚本生成器。

- **特点**：简单直接。它只接收脚本名称和内容，**不包含** `runtimeInputs` 这种自动补全 `$PATH` 的功能，也不运行 `shellcheck` 校验。
- **适用场景**：非常简短的单行脚本，或者你已经习惯手动写全路径（如 `${pkgs.curl}/bin/curl`）的情况。
- **输出路径**：`/nix/store/...-name/bin/name`。

### 2. `writeScriptBin`

比上面的更底层，它甚至不强制要求是 Shell 脚本。

- **特点**：你需要手动在字符串开头写上 Shebang（例如 `#!/usr/bin/env python3`）。它只是把字符串存成文件并赋予 `+x` 权限。
- **适用场景**：编写非常简单的 Python、Perl 或 Ruby 脚本，且不依赖复杂的库。

### 3. 语言专用 Writers (如 `writePython3Bin`, `writeJSBin`)

Nixpkgs 为主流编程语言提供了专门的包装器。

- **特点**：
  - **自动 Shebang**：自动指向正确的解释器。
  - **库依赖（Libraries）**：允许你传入该语言的包依赖。例如 `writePython3Bin` 可以接收 `libraries = [ pkgs.python3Packages.requests ];`。
- **示例**：
  ```nix
  pkgs.writePython3Bin "check-api" { libraries = [ pkgs.python3Packages.requests ]; } ''
    import requests
    print(requests.get("https://google.com").status_code)
  ''
  ```

---

### 4. `writeTextFile` (万物之源)

这是所有上述函数的底层实现。

- **特点**：高度可定制。你可以指定文件名、目标路径、是否可执行、以及在构建完成后执行的检查指令（`checkPhase`）。
- **适用场景**：当你需要生成非可执行配置文件（如 `nginx.conf`）或者有极其特殊的构建需求时。

---

### 5. 核心差异对比表

| 函数名称                    | 自动 Shebang | 语法校验        | 依赖管理             | 推荐用途                               |
| :-------------------------- | :----------- | :-------------- | :------------------- | :------------------------------------- |
| **`writeShellApplication`** | ✅ (Bash)    | ✅ (ShellCheck) | ✅ (`runtimeInputs`) | **最推荐**。用于复杂的运维脚本。       |
| **`writeShellScriptBin`**   | ✅ (Bash)    | ❌              | ❌ (需手动拼接路径)  | 极其简单的快速脚本。                   |
| **`writePython3Bin`**       | ✅ (Python)  | ❌              | ✅ (`libraries`)     | 替代复杂的 Shell，用 Python 处理逻辑。 |
| **`writeTextFile`**         | ❌           | 自定义          | ❌                   | 生成配置文件或非二进制文件。           |

---

### 💡 为什么 `writeShellApplication` 现在是主流？

在 `writeShellApplication` 出现之前，大家普遍使用 `writeShellScriptBin`。但后者经常导致**“环境污染”**：

> 如果你的脚本里写了 `curl`，但你忘了在 Nix 环境里装 `curl`，脚本在你的机器上能跑（因为你系统里有），但在别人机器上就崩了。

`writeShellApplication` 通过 `runtimeInputs` 强制你声明依赖，并用 **Wrapper** 隔离了外部环境，这才是真正的 **Nix 哲学**。

**既然你已经在用 `writeShellApplication` 了，要不要尝试在 `apply-up` 里加一个简单的语法检查，或者用 `writePython3Bin` 写一个更复杂的 Mac 系统监控脚本？**
