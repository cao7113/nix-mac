# Mise

Saying: more faster than asdf...

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

## Links

- https://mise.jdx.dev/getting-started.html
- https://github.com/jdx/mise
