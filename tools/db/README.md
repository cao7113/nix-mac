# Services

```
# 查看服务状态 (是否在运行，退出码是多少)
launchctl list | grep nixos

# 强制停止一个服务
launchctl kickstart -k gui/$(id -u)/org.nixos.syncthing

# 查看系统日志中关于该服务的输出
log show --predicate 'subsystem == "com.apple.launchd"' --last 10m
```
