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
        theme = "Catppuccin Mocha";
        font-size = 14;
        font-family = "JetBrainsMono Nerd Font";
        background-opacity = 0.9;
        background-blur = true;
        # 完美匹配你用 Nix 管理的 Zsh/Fish
        command = "${pkgs.zsh}/bin/zsh";
      };
    };
  };

}
