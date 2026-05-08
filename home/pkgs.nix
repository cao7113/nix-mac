{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello

    zoxide # 智能路径跳转：基于权重学习你的目录访问习惯 (替代 cd)
    bat # 增强型 cat：提供语法高亮，常作为 fzf 的预览器
    go-task
    # eza # 增强型 ls：支持图标显示和 Git 状态集成

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # neovim
  ];
}
