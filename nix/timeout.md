```
sudo nix run "nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ".#mac" --show-trace --impure
warning: $HOME ('/Users/rj') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
warning: unable to download 'https://api.github.com/repos/nix-darwin/nix-darwin/commits/nix-darwin-26.05': Timeout was reached (28) Resolving timed out after 15001 milliseconds; retrying in 317 ms (attempt 1/5)
warning: unable to download 'https://api.github.com/repos/nix-darwin/nix-darwin/commits/nix-darwin-26.05': Timeout was reached (28) Resolving timed out after 15001 milliseconds; retrying in 686 ms (attempt 2/5)
warning: unable to download 'https://api.github.com/repos/nix-darwin/nix-darwin/commits/nix-darwin-26.05': Timeout was reached (28) Resolving timed out after 15001 milliseconds; retrying in 1289 ms (attempt 3/5)
warning: unable to download 'https://api.github.com/repos/nix-darwin/nix-darwin/commits/nix-darwin-26.05': Timeout was reached (28) Resolving timed out after 15001 milliseconds; retrying in 2741 ms (attempt 4/5)
error:
       … while fetching the input 'github:nix-darwin/nix-darwin/nix-darwin-26.05'

       error: unable to download 'https://api.github.com/repos/nix-darwin/nix-darwin/commits/nix-darwin-26.05': Timeout was reached (28) Resolving timed out after 15001 milliseconds
```

## 解决办法

客户端和daemon都开启http proxy！！！

也可尝试从已下载的nix-darwin源码运行上面的命令

sudo http_proxy=$http_proxy https_proxy=$https_proxy nix run "nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ".#mac" --show-trace --impure


分两步
先下载（使用当前proxy环境变量）
nix build ".#darwinConfigurations.mac.system" --no-link 
后激活
sudo darwin-rebuild switch --flake ".#mac" --impure
sudop nix run "nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ".#mac" --show-trace --impure


[0/58 built, 16/1/53 copied (90.4/932.5 MiB), 19.9/176.7 MiB DL] fetching openssl-3.6.2 from https://cache.nixos.org
[0/58 built, 16/0/54 copied (2.3/929.7 MiB), 676.0 KiB/175.8 MiB DL] fetching vim-darwin-9.2.0389 from https://cache.nixos.org


- https://gemini.google.com/app/1f63df5ade15fb68


```
针对大文件和网络波动的 nix.conf 续命参数
如果你所处的网络环境极其恶劣，经常莫名其妙断流导致单个大包频繁重头开始，可以在你的 ~/.config/nix/nix.conf（或系统的 /etc/nix/nix.conf）里加入以下底层 libcurl 微调参数：

Plaintext
# 如果下载速度连续 15 秒低于 100 字节/秒，直接判定为卡死并触发重试，不用傻等 15 分钟
stalled-download-timeout = 15

# 单个包下载失败后的最大重试次数（默认是 5 次，网络差可以改成 10 次）
download-attempts = 10

# 开启 HTTP/2 多路复用，极大提升在代理环境下的并发下载效能
http2 = true
```
