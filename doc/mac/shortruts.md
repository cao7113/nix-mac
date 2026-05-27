# Shortcuts Raycast Alfred

在 macOS 生态中，**Apple Shortcuts（快捷指令）**、**Raycast** 和 **Alfred** 是自动化与效率工具的三驾马车。虽然功能有交集，但它们的核心哲学、架构以及适用场景有着本质区别。

我们可以从**系统集成度、扩展开发生态、执行性能、秘密/配置管理**等深度维度进行对比。

---

## 核心哲学与架构对比

| 维度 | Apple Shortcuts (快捷指令) | Raycast | Alfred |
| --- | --- | --- | --- |
| **定位** | 系统级原生自动化流水线 | 现代化、以社区插件驱动的 CLI-like 启动器 | 老牌、轻量、以本地 Workflow 为核心的效率中心 |
| **架构与性能** | 基于系统原生的 AppleScript/SiriKit，某些复杂场景下有轻微 UI 延迟。 | 基于 **React + TypeScript (Node.js/Bun)**。性能极高，拥有原生级 UI 渲染。 | 基于 **Objective-C/C** 编写。极致轻量，内存占用极小，几乎零延迟。 |
| **交互逻辑** | 菜单栏、快捷键、小组件、自动化触发（事件驱动）。 | 纯键盘驱动（Command + Space 替代者），全局命令面板。 | 纯键盘驱动，依赖关键字（Keyword）和快捷键触发。 |

---

## 深度维度对比

### 1. 自动化与系统集成度

* **Shortcuts:** 拥有**最高的系统权限**。它可以直接控制沙盒（Sandbox）内的原生应用（如 Calendar, Reminders, Photos），完美支持系统级事件触发（如：连接到特定 Wi-Fi 时、特定时间、或者文件投递到某个文件夹时自动运行）。
* **Raycast & Alfred:** 它们主要依赖 macOS 的 **Accessibility API（辅助功能）** 或 AppleScript 来间接控制系统。无法像 Shortcuts 那样做到真正的“事件监听自动化”，它们更倾向于“用户主动触发”。

### 2. 开发者生态与扩展能力

* **Shortcuts:** 采用可视化积木（Drag-and-Drop）搭建。虽然支持嵌入 Shell 脚本或 JavaScript，但由于缺乏真正的版本控制（Git-friendly）、文本化的代码格式以及完善的调试器，编写复杂逻辑时非常痛苦。
* **Raycast:** **现代开发者的天堂**。官方提供了开箱即用的 React API，允许开发者使用 TypeScript 编写扩展，甚至可以直接渲染出极其精美的原生 UI 界面（List, Detail, Form）。由于扩展本质上是 npm 项目，因此对 Git 友好，生态更新极快。
* **Alfred:** 传统的 **Workflow（工作流）** 机制。它支持几乎任何脚本语言（Python, Bash, Zsh, PHP, Ruby, Go）。Alfred 的优势在于其图形化的数据流连线设计（Trigger -> Filter -> Action），但在处理复杂的 UI 输入反馈时，不如 Raycast 的 React 界面那么现代化。

### 3. 配置与秘密管理（Secrets Management）

对于高级用户（如开发者），如何安全地存储 API Key、Token 等敏感信息至关重要：

* **Shortcuts:** 敏感信息通常只能硬编码在文本块中，或者借由第三方的第三方工具（如通过本地文件读取）来间接管理，安全性一般。
* **Raycast:** 内置了安全的 `Arguments` 和 `Password` 类型配置。插件发布时，敏感配置会被加密存储在 macOS Keychain 中，且不会源码外泄，管理非常优雅。
* **Alfred:** Workflow 支持环境变量（Environment Variables），并提供专用勾选项将变量标记为 `Don't Export`（不导出）。这些数据同样可以安全地存储在本地，且在分享 Workflow 时会自动被剔除。

---

## 三者如何联动？（最佳实践）

在实际的高级工作流中，这三者绝对不是排他的，**最佳的方案是让 Raycast/Alfred 作为“前端触发器”，而 Shortcuts 作为“后端执行引擎”**。

> **场景示例：一键加入会议并调整环境**
> 1. 你在 **Raycast / Alfred** 中输入 `join`。
> 2. 触发一个脚本，该脚本通过 `shortcuts run "Join Meeting"` 命令行工具调用 **Shortcuts**。
> 3. **Shortcuts** 执行系统级高权限操作：打开 Zoom、将 Mac 设为勿扰模式、通过 HomeKit 关闭房间顶灯。
> 
> 

### 总结选型建议

* **选择 Shortcuts 如果：** 你需要高权限的系统原生自动化（如：定时任务、文件监控、跨 Apple 设备同步、操控原生 App），且不需要复杂的自定义键盘 UI。
* **选择 Raycast 如果：** 你是现代 Web 开发者，喜欢 TypeScript/React 生态，渴望一站式管理 GitHub、Linear、Notion，并且追求极致的视觉一致性和中心化命令面板。
* **选择 Alfred 如果：** 你是老牌 Power User，对内存和响应速度有极致压榨要求（比如老款设备），拥有大量自己用 Python/Go/Shell 写的本地脚本工作流，且习惯了它延续十年的稳定交互。