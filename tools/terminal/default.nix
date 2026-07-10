{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  homebrew = {
    casks = lib.optionals (need_least "brewer") [
      # HashiCorp 创始人 Mitchell Hashimoto 用 Zig 语言重写的明星级终端
      "ghostty"

      # "iterm2"
      # WezTerm(Rust
      # "wezterm"
    ];
  };

  home-manager.users.${username} = {
    programs.ghostty = {
      enable = true;
      package = null; # 👈 关键：不让 home-manager 安装主程序

      settings = {
        # --- 基础视觉与字体 ---
        theme = "Catppuccin Mocha";
        font-size = 14;
        font-family = "JetBrainsMono Nerd Font";
        background-opacity = 0.9;
        background-blur = true;

        # --- 核心 Shell 联动 ---
        # 完美匹配你用 Nix 管理的 Zsh/Fish
        command = "${pkgs.zsh}/bin/zsh";

        # --- 工业级现代窗口管理 (macOS 原生感) ---
        title = " "; # 隐藏冗余的路径标题，保持极简
        macos-option-as-alt = true; # 将 Option 键映射为 Alt，完美适配 Emacs/Vim/Nix 命令行快捷键（如 Alt+f/b 移动光标）
        window-padding-x = 10; # 工业级内边距，长时间写代码眼睛更舒适
        window-padding-y = 10;
        window-save-state = "default"; # 记住崩溃前或关闭前的窗口状态与路径
        confirm-close-surface = true; # 生产环境下效率至上，关闭活跃会话时无需二次弹窗确认

        # --- 剪贴板安全与现代鼠标行为 (解决双击/选中无法复制的底层真相) ---
        # 1. 显式允许剪贴板读写（防止 macOS 权限或安全策略拦截）
        clipboard-read = "allow";
        clipboard-write = "allow";

        # 2. 强行禁止底层程序（如 tmux/fzf/zsh 鼠标增强插件）抢占鼠标
        # 设为 false 后，Ghostty 将独占最高鼠标控制权，彻底还原 macOS 纯正的双击选中、拖动高亮体验！
        mouse-shift-capture = false;

        # --- 强悍的资深开发者快捷键矩阵 (Keybinds) ---
        "keybind" = [
          # 3. 如果你的 Cmd+C / Cmd+V 依然被特定 Shell 插件拦截，在此强制绑定回系统剪贴板
          "cmd+c=copy_to_clipboard"
          "cmd+v=paste_from_clipboard"

          # 4. 极速窗口与标签页导航 (摆脱 tmux 依赖，享受 GPU 加速的轻量分屏)
          "cmd+d=new_split:right" # 水平分屏 (同 iTerm2 习惯)
          "cmd+shift+d=new_split:down" # 垂直分屏 (同 iTerm2 习惯)
          "cmd+h=goto_split:left" # 分屏间快速跳转 (HJKL 核心方向)
          "cmd+j=goto_split:bottom"
          "cmd+k=goto_split:top"
          "cmd+l=goto_split:right"

          # 5. 标签页管理 (Tabs)
          "cmd+t=new_tab"
          "cmd+w=close_surface" # 关闭当前分屏或当前 Tab
          "cmd+shift+]=next_tab" # 快速轮换 Tab
          "cmd+shift+[=previous_tab"

          # 6. 高级调试与热重载
          "cmd+ctrl+,=reload_config" # 强制热重载 Ghostty 配置
          "cmd+ctrl+f=toggle_fullscreen" # 极客无边框全屏模式切换
        ];
      };
    };
  };
}
