# VM

## UTM

- https://mac.getutm.app/

```
brew install utm
```

## 共享Host主机代理设置

- ShadowsocksX-NG Settings -> HTTP -> HTTP Proxy Listen Address: 0.0.0.0 (instead origin 127.0.0.1)
- VM Guest set: curl -x http://192.168.64.1:1087 https://www.google.com

## 复制粘贴 & 屏幕共享

用宿主机的「屏幕共享」应用去连虚拟机。这样不仅能完美解决文本复制粘贴，连文件拖拽、动态分辨率缩放都能完美支持。

第一步：在虚拟机内开启共享
在虚拟机里，打开 系统设置 -> General (通用) -> Sharing (共享)。

找到 Screen Sharing (屏幕共享)，将其打开。

点击它旁边的 i (信息) 图标，查看虚拟机的 IP 地址（通常是 192.168.X.X 或 10.211.X.X）。

第二步：在宿主机上连接
回到你的宿主机，按下快捷键 Cmd ⌘ + Space 唤起 Spotlight 搜索，输入并打开 屏幕共享 (Screen Sharing) 应用。

在连接地址栏输入虚拟机的 IP 地址（或者输入 vnc://虚拟机IP），点击连接。
`vnc://192.168.64.2`

输入虚拟机账号的密码登录。

💡 体验提升： 连上之后，你可以把 UTM 的虚拟机窗口最小化（但不要关闭），直接在宿主机的「屏幕共享」窗口里操作虚拟机。此时，你会发现两边的剪贴板和文件拖拽变得异常丝滑，因为这是 macOS 骨子里原生支持的远程协议。

## Tart

```
# nix way
NIXPKGS_ALLOW_UNFREE=1 nix profile add nixpkgs#tart --impure

# brew way
brew trust cirruslabs/cli
brew install cirruslabs/cli/tart
```