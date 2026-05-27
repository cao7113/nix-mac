# Mac loves Nix

My `nix-darwin` + `home-manager` setup, using Determinate Nix to manage the macOS environment.

## Overview

- Use `determinate-nix` to install and manage the Nix version.
- `nix-mac` is a public repository based on `nix-darwin` + `home-manager`, managing essential macOS software like `zsh`, `postgresql`, etc.
- `dot-sec` is a private repository based on `home-manager`, managing private configuration data, including `sops-nix`, `age`, `ssh`, and more.
- `dot-sec` is a standalone git repo, symlinked to `~/.sec` as an optional `home-manager` submodule.
  - If `~/.sec` exists, it will be deployed together with `darwin-rebuild`.
  - If it doesn't exist, it won't affect the `nix-darwin` deployment—just a missing notice will be shown.

## Quick Start

1. Install Determinate Nix.
2. Clone the `nix-mac` repository.
3. Run `darwin-rebuild` to switch configurations.
4. Run `iup` for further initialization.

## Setup

### 1. Prerequisites

- Sign in to your Apple ID and ensure a stable internet connection.
- Installing `Homebrew` and `Xcode Command Line Tools` may require significant downloads.

### 2. Install Determinate Nix

Recommended: use the Determinate Nix Installer:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

For the pkg installer, see:
- https://docs.determinate.systems/getting-started/individuals/
- https://install.determinate.systems/determinate-pkg/stable/Universal

References:
- https://zenn.dev/trifolium/articles/da11a428c53f65?locale=en
- https://github.com/NixOS/nix-installer
- https://github.com/DeterminateSystems/nix-installer

Test the installation:

```bash
nix shell nixpkgs#hello
nix shell nixpkgs#hello --command hello --version
nix run nixpkgs#hello -- --version
nix shell github:NixOS/nixpkgs/nixos-unstable#hello
nix run nixpkgs#cowsay -- "Hello"
# nix shell nixpkgs#pkg1 nixpkgs#pkg2
```

### 3. Install `nix-mac`

```bash
# First time
mkdir -p ~/dev && cd ~/dev
git clone -v --depth=3 https://github.com/cao7113/nix-mac.git
cd nix-mac
sudo nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake .#mac --show-trace --impure
# Then
iup
```

### 4. Install Xcode Command Line Tools

```bash
xcode-select --install
# Check the current path:
xcode-select -p
```

## Notes & Recommendations

### Homebrew

If your network is unstable, you can temporarily comment out the Homebrew section in `flake.nix`.

### VSCode Extensions

It is recommended to install `jnoortheen.nix-ide`:

- https://github.com/nix-community/vscode-nix-ide?tab=readme-ov-file#language-servers

### Flakehub CLI (`fh`)

```bash
nix profile add github:DeterminateSystems/fh
# Temporary shell install:
nix shell "https://flakehub.com/f/DeterminateSystems/fh/*"

nix run github:DeterminateSystems/fh -- --help
fh --version
```

### Generate Initial SSH Key

```bash
gh auth login
gh ssh add ~/.ssh/id_ed25519.pub
```

### GitHub API Rate Limits

See:

- https://devenv.sh/getting-started/#3-configure-a-github-access-token-optional

### Proxy Settings

If your network is unstable, you can use ShadowsocksNG:

```bash
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
```

## References

- https://callistaenterprise.se/blogg/teknik/2025/05/28/nix-darwin/
- https://github.com/HestHub/nixos
- https://github.com/nix-darwin/nix-darwin
- https://nix-darwin.github.io/nix-darwin/manual/index.html
- https://home-manager-options.extranix.com/?query=direnv&release=release-25.11
- https://nix.dev/manual/nix/2.28/introduction.html
- https://github.com/NixOS/flake-registry/blob/master/flake-registry.json
- https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#examples
