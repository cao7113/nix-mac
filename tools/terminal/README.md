# Terminals

# iTerm2

* nix能配置iterm2配置dark theme吗?
    不太能，可设置好后保存，让home-manager管理以便下次iterm2自动加载
    Dark配置方法： Settings -> Apperance -> Theme: Dark
    新tab保留上次位置：&，-> Profiles -> Default -> Initial directory

* 支持直接在设置中勾选 `"Load preferences from a custom folder"`（从自定义文件夹加载配置），你只需把这个文件夹丢给 `chezmoi`，就能实现无痛秒级同步。

## Mac builtin Terminal

备用，感觉还行

### 💡 独立开发者的小建议

如果你对终端的颜值、快捷键和跨平台同步有极高的要求，macOS 社区普遍的做法是**放弃系统自带的 Terminal.app**，转而使用以下两款开源的现代终端：

*   **iTerm2：** 老牌神器。支持直接在设置中勾选 `"Load preferences from a custom folder"`（从自定义文件夹加载配置），你只需把这个文件夹丢给 `chezmoi`，就能实现无痛秒级同步。
*   **Alacritty / Kitty / WezTerm：** 现代 GPU 加速终端。它们的配置**原生就是纯文本**（`.toml` 或 `.lua`），完美契合 `chezmoi` 的设计哲学，不需要任何转换黑魔法。