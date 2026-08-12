# Mise - More powerful than asdf!

- https://mise.jdx.dev/getting-started.html
- built in Rust
- For tools or settings you want to keep private, use mise.local.toml

## Config

mise supports nested configuration files that cascade from broad to specific settings:

```
~/.config/mise/config.toml - Global settings for all projects
~/work/mise.toml - Work-specific settings
~/work/project/mise.toml - Project-specific settings
~/work/project/mise.local.toml - Project-specific settings that should not be shared
```

## Github rate-limit

- https://mise.jdx.dev/dev-tools/backends/github.html#github.use_git_credentials

原因：gh token 存在 macOS Keychain，mise 默认不会通过 Git 的 Keychain helper 读取它。你的 Git 已配置 osxkeychain，只需启用 mise 的该回退机制：

```
mise settings set github.use_git_credentials true
mise token github

❯ mise tool sing-box
mise WARN  GitHub rate limit exceeded. Resets at 2026-08-12 11:44:13 +08:00
Backend:            github:sagernet/sing-box
Installed Versions:
Tool Options:       [none]
Security:           [none]

~/tmp
❯ mise token github
github.com: (none)
```

## prerelease版本安装

可以直接指定 alpha/beta 的版本号；`github:` 后端会自动处理 Git tag 常见的 `v` 前缀：

```zsh
mise use -g github:sagernet/sing-box@1.14.0-alpha.50
```

这会安装并全局启用 `v1.14.0-alpha.50`。验证：

```zsh
sing-box version
mise ls github:sagernet/sing-box
```

仅安装、不修改全局默认版本：

```zsh
mise install github:sagernet/sing-box@1.14.0-alpha.50
```

如果希望 `latest` 也包含 alpha / beta 等预发布版本，使用：

```zsh
mise use -g 'github:sagernet/sing-box[prerelease=true]@latest'
```

对应的 TOML 写法是：

```toml
[tools."github:sagernet/sing-box"]
version = "latest"
prerelease = true
```

`prerelease = true` 影响 `latest`、模糊版本匹配和 `mise ls-remote`；安装像 `1.14.0-alpha.50` 这样的精确版本时通常不需要它。参考 [mise GitHub backend 的 prerelease 配置](https://mise.jdx.dev/dev-tools/backends/github.html)。

## Links

- https://github.com/jdx/mise
