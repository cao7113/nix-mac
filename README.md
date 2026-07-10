# Mac loves Nix

My `nix-darwin` + `home-manager` setup and macOS recipies.

## Setup

```

# init setup
curl -fsSL https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.zsh | command zsh -s
# try below when blocked
curl -fsSL https://ghproxy.net/https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.zsh | command zsh -s
curl -fsSL https://cdn.jsdelivr.net/gh/cao7113/nix-mac@main/setup.zsh | command zsh -s
curl -fsSL https://gitmirror.com/https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.zsh | command zsh -s

# 上面的会使用默认代理。。。如需要配置代理，需要
[[ ! -f /tmp/mac.sh ]] && curl -fsSL https://ghproxy.net/https://raw.githubusercontent.com/cao7113/nix-mac/main/setup.zsh > /tmp/mac.sh && chmod +x /tmp/mac.sh && /tmp/mac.sh
# /tmp/mac.sh

# daily use
mdp # iup
```

## Overview

- Use `nix/installer/official-installer` to install and manage the Nix version.
- `nix-mac` is a public repository based on `nix-darwin` + `home-manager`, managing essential macOS software like `zsh`, `postgresql`, etc.
- `dot-sec` is a private repository based on `home-manager`, managing private configuration data, including `sops-nix`, `age`, `ssh`, and more.
  - `dot-sec` is a standalone git repo, symlinked to `~/.sec` as an optional `home-manager` submodule.
    - If `~/.sec` exists, it will be deployed together with `darwin-rebuild`.
    - If it doesn't exist, it won't affect the `nix-darwin` deployment—just a missing notice will be shown.
- `main.zsh` is the zsh rc entry file

### Test nix

```bash
nix shell "nixpkgs#hello"
nix shell "nixpkgs#hello" --command hello --version
nix run "nixpkgs#hello" -- --version
nix shell "github:NixOS/nixpkgs/nixos-unstable#hello"
nix run "nixpkgs#cowsay" -- "Hello"
# nix shell nixpkgs#pkg1 nixpkgs#pkg2
```

## UTM try

```
proxy host: 192.168.64.1
```

## Notes

### Generate SSH Key

```bash
gh auth login
gh ssh add ~/.ssh/id_ed25519.pub
```

### GitHub API Rate Limits

- https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional

```
mise WARN  GitHub rate limit exceeded. Resets at 2026-07-08 15:45:49 +08:00                  ◠
mise WARN  GitHub API returned a 403 Forbidden error. This is most commonly caused by exceeding the rate limit, though other causes (e.g. insufficient token permissions) are possible.
mise WARN  No GitHub token was found, so mise is making unauthenticated requests to GitHub which have a much lower rate limit.
Create a token at https://github.com/settings/tokens (no scopes required) and set it as GITHUB_TOKEN in your environment.
See https://mise.en.dev/dev-tools/github-tokens.html for all supported token sources (env vars, gh CLI, credential_command, etc.).
```

### Proxy Settings

If your network is unstable, use ShadowsocksNG:

- https://github.com/shadowsocks/ShadowsocksX-NG/releases/tag/v1.10.3

```bash
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
```

## References

- https://github.com/nix-community/home-manager
- https://home-manager-options.extranix.com/?query=direnv&release=release-26.05
- https://github.com/nix-darwin/nix-darwin
- https://nix-darwin.github.io/nix-darwin/manual/index.html
- https://callistaenterprise.se/blogg/teknik/2025/05/28/nix-darwin/
- https://github.com/HestHub/nixos
- https://nix.dev/manual/nix/2.28/introduction.html
