# Installing Lix

nix-darwin recommend 

- https://github.com/nix-darwin/nix-darwin#prerequisites
- https://lix.systems/install/#on-any-other-linuxmacos-system
- https://git.lix.systems/lix-project/lix-installer/releases 

## Code

- https://github.com/lix-project/lix
- https://git.lix.systems/lix-project/lix-installer
- https://git.lix.systems/lix-project

## 研究问题

- 熟悉installer 脚本逻辑
- 网络设置是否支持代理，尽量优化成可脱网执行
- 版本升级
- 光滑卸载和重演

## install.sh 脚本调试

脚本主要功能
- 根据运行环境拼接installer下载链接(可使用NIX_INSTALLER_BINARY_ROOT，NIX_INSTALLER_OVERRIDE_URL定制)
- 添加curl重试/断点续传/安全套件等现代安全参数
- 下载lix-installer到临时可执行文件并运行


```
https://install.lix.systems/lix/lix-installer-aarch64-darwin

curl --retry 3 --continue-at - --speed-limit 250000 --speed-time 15 --proto '=https' --tlsv1.2 --ciphers "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384" --silent --show-error --fail --location https://install.lix.systems/lix/lix-installer-aarch64-darwin --output /var/folders/r0/t1kgzm197y18n6jchmm8ft2r0000gn/T/tmp.spxFHfrfGV/lix-installer
```

### 本地快速体验

- 本地可使用下面的链接直接下载，赋予可执行权限，安全授权后执行
- lix-installer是一个可独立运行的程序，大概 ~7M

```
./tmp-lix-installer 
The Lix installer

Usage: tmp-lix-installer [OPTIONS] <COMMAND>

Commands:
  install        Install Lix-Nix using a planner
  repair         Various actions to repair Nix installations
  uninstall      Uninstall a previously `nix-installer` installed Nix
  self-test      Run a self test of Nix to ensure that an install is working
  plan           Emit a JSON install plan that can be manually edited before execution
  split-receipt  Split an existing receipt into two phases, one that cleans up the Nix store (phase 2), and one that does everything else (phase 1)
  help           Print this message or the help of the given subcommand(s)

Options:
      --proxy <PROXY>
          The proxy to use (if any); valid proxy bases are `https://$URL`, `http://$URL` and `socks5://$URL` [env: NIX_INSTALLER_PROXY=]
      --ssl-cert-file <SSL_CERT_FILE>
          An SSL cert to use (if any); used for fetching Nix and sets `ssl-cert-file` in `/etc/nix/nix.conf` [env: NIX_INSTALLER_SSL_CERT_FILE=]
  -v, --verbose...
          Enable debug logs, -vv for trace [env: NIX_INSTALLER_VERBOSITY=]
      --logger <LOGGER>
          Which logger to use (options are `compact`, `full`, `pretty`, and `json`) [env: NIX_INSTALLER_LOGGER=] [default: compact] [possible values: compact, full, pretty, json]
      --log-directive [<LOG_DIRECTIVES>...]
          Tracing directives delimited by comma [env: NIX_INSTALLER_LOG_DIRECTIVES=]
  -h, --help
          Print help (see more with '--help')
  -V, --version
          Print version
```