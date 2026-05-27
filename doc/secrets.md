# secrets management

- https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes

- https://github.com/Mic92/sops-nix
  - 2.7k
- https://github.com/ryantm/agenix
  - 2.3k

在 nix-darwin 和 NixOS 生态中，处理私密数据（Secrets）最好的方案公认是 sops-nix。
虽然还有 agenix 等替代品，但 sops-nix 凭借其强大的编辑器支持、云端集成（KMS）以及对 age 和 PGP 的完美兼容，成为了目前的事实标准。

sudo -u other_user
open "x-apple.systempreferences:com.apple.preferences.AppleID"

模块化解耦：如果你的 \_home.nix 变得越来越大，我们可以把它拆成 shell.nix, git.nix, editor.nix。

Secret 管理集成：既然你对 age/SOPS 感兴趣，我们可以研究如何把密钥注入到这个 Nix 配置中，实现敏感配置（如 SSH Key 路径或 API Token）的加密存储。

Swift 工具集成：我们可以把你的 kc-util 也写成一个 Nix Derivation，让它直接出现在你的系统 PATH 中。
