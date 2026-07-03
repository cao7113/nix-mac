# Launchd & LaunchAgent & LaunchDaemon

在现代 macOS（Ventura 及更高版本）中，用户可以在“系统设置 -> 通用 -> 登录项”中更直观地管理这些后台服务的开启与关闭。

## LaunchAgents

~/Library/LaunchAgents 仅为当前用户定义的代理程序。

/Library/LaunchAgents：第三方软件为系统中所有用户提供的代理程序。

/System/Library/LaunchAgents：Apple 官方提供的用户级组件。

## LaunchDaemons

/Library/LaunchDaemons：第三方软件提供的系统级服务（需要管理员权限修改）。
/System/Library/LaunchDaemons：Apple 官方系统组件（不可修改）。
