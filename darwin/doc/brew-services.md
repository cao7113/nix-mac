# brew services

命令,说明
brew services list,列出所有由 brew 管理的服务及其运行状态。
brew services run <formula>,立即启动服务，但不会在下次开机时自动启动。
brew services start <formula>,启动服务，并注册为开机自启。
brew services stop <formula>,停止服务，并取消开机自启。
brew services restart <formula>,重启服务。
brew services cleanup,清除不再使用的已停止服务的配置文件。
