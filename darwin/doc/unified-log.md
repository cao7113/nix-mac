# 统一日志系统（Unified Logging System）

在 macOS 的底层世界中，/usr/bin/log 是透视整个操作系统运作的“上帝之眼”。无论是排查 launchd 服务闪退、寻找内核崩溃原因，还是追踪 App 的异常行为，都离不开它。

Apple 在 2016 年推出了全新的 统一日志系统（Unified Logging System）。它将内核空间（Kernel）和用户空间（User Space）的日志彻底合并，并引入了全新的压缩与内存缓冲机制。/usr/bin/log 正是进入这个新世界的唯一官方命令行钥匙。

## daily usage

```
log stream --info --predicate 'process == "launchd" AND eventMessage CONTAINS "com.visualstudio"'
# 实时查看 keychaindp 的同步日志（26.3 专用谓词）
log stream --predicate 'process == "keychaindp"' --level info

log show --predicate 'process == "keychaindp" OR process == "securityd"' --last 5m
log help show
```


## Console.app

- 可图形化查看log，🎉！

## logger

logger 命令发出，最稳妥的是过滤 process == "logger" 或匹配日志内容

```
sudo log stream --predicate 'process == "logger"' --level info

# bad: -t 没啥鸟用
logger -t "abc" -p user.info "some msg" 
```

## newsyslog

log文件滚动

## setup

```
ls -l /var/db/diagnostics/

❯ which -a log
log: shell built-in command
/usr/bin/log

man logger # classic syslog client, use log emit "some msg" instead
```