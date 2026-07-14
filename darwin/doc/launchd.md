# Launchd & LaunchAgent & LaunchDaemon

在现代 macOS（Ventura 及更高版本）中，用户可以在“系统设置 -> 通用 -> 登录项”中更直观地管理这些后台服务的开启与关闭。

Mac开机时，内核启动的第一个用户态进程就是 launchd（PID 为 1）

- https://www.launchd.info/

## 触发条件（由 Plist 决定）：

条件 A (RunAtLoad): 只要一加载（或系统一启动），立刻生成进程。

条件 B (KeepAlive): 强制保持活着，挂了立刻重启。

条件 C (StartInterval / StartCalendarInterval): 定时触发（类似 crontab）。

条件 D (WatchPaths / QueueDirectories): 当某个文件发生变化或文件夹有新文件时触发。

条件 E (Sockets): 网络套接字激活。当有网络流量进来到指定端口时，进程才会被瞬间拉起（常用于网络服务）。

进程生成 (Spawn)：
一旦条件满足，launchd 底层会调用 fork() 和 exec()，正式创建你的 test.daemon 进程，并为其分配 PID。此时服务进入 Running 状态。

## 如果plist文件中没配置StandardOutPath输出会写到哪里？

StandardOutPath 和 StandardErrorPath，launchd 会在此阶段重定向你的重定向标准输出，将日志写入指定文件。

## 使用log 打出某个plist管理的service的一生

## launchctl

新版本 macOS 引入了更安全、基于“领域（Domain）”概念的子命令。
旧语法 load 只是简单地读取文件，而新语法强制你指定 Target Domain（目标领域）。
gui/501：表示“用户 ID 为 501 的图形界面会话”。这保证了任务能准确获取该用户的桌面、环境变量和图形上下文。
system：表示“系统全局领域”。

## tools

```
brew install --cask launchcontrol
brew install booter
```

## env

```
# env
# 1. 设置一个临时全局变量
launchctl setenv MY_TEMP_VAR "hello_world"
# 2. 检查变量是否设置成功
launchctl getenv MY_TEMP_VAR
# 3. 卸载该环境变量
launchctl unsetenv MY_TEMP_VAR
```

## LaunchAgents

用户代理进程 只有在特定用户登录后才会启动，在用户的图形界面上下文（Session）中运行，权限与当前登录的用户相同。

- ~/Library/LaunchAgents 仅为当前用户定义的代理程序。
- /Library/LaunchAgents：第三方软件为系统中所有用户提供的代理程序。
- /System/Library/LaunchAgents：Apple 官方提供的用户级组件。

## LaunchDaemons

系统守护进程。与用户登录状态无关。无论有没有用户登录，只要 Mac 开机，它们就在后台运行。通常以 root 最高权限运行。

- /Library/LaunchDaemons：第三方软件提供的系统级服务（需要管理员权限修改）。
- /System/Library/LaunchDaemons：Apple 官方系统组件（不可修改）。

