# Launchd & Launchctl

现代基于domain的加载

- system          -> daemon
- gui/$(id -u)    -> agent
- user/$(id -u)   -> agent  # user background job

## 场景

- 可用来执行定时任务

## user域

以你的用户身份运行，但被剥离了 GUI 权限，且不受你是否注销桌面的影响。


### 系统在什么情况下会自动把服务加载到 user 域？

你可能会问：“如果我不手动执行命令，系统自己是怎么分流 gui 域和 user 域的？”

Apple 引入了一个隐藏的配置项叫做 LimitLoadToSessionType（限制加载的会话类型）。在 .plist 文件中，你可以通过这个标签来强制规定这个服务属于哪个域：

```
<key>LimitLoadToSessionType</key>
<array>
    <string>Background</string> 
</array>
```

系统的分流规则：
当系统检测到 ~/Library/LaunchAgents/ 下的 .plist 文件时，它会读取这个标签：

如果没有写这个标签，或者写了 Aqua：系统认为这是一个常规的、需要界面的 Agent，在用户登录桌面时，自动将其加载到 gui 域。

如果写了 Background：系统认为这是一个纯后台服务，不论用户有没有登录桌面（比如通过 SSH 触发了用户激活），都会自动将其加载到 user 域。

