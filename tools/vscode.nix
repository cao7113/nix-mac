{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # VS Code
  home-manager.users.${username} = {
    programs.vscode = {
      enable = true;

      profiles.default = {
        # 自动管理扩展插件（可选）
        extensions = with pkgs.vscode-extensions; [
          # vscodevim.vim # 如果你用 Vim 的话
          # github.copilot
        ];

        # 你的核心诉求：在这里配置 VS Code 的全局 Settings
        userSettings = {
          # 缩进与 Tab 键配置
          "editor.tabSize" = 2; # Tab 键等于 2 个空格
          "editor.insertSpaces" = true; # 按 Tab 键时插入空格而非制表符
          "editor.detectIndentation" = false;

          # 推荐的辅助配置（让视觉更清晰）
          "editor.renderWhitespace" = "selection"; # 选中时显示空白字符
          "editor.guides.indentation" = true; # 显示缩进参考线

          # 一些适合 Mac (nix-darwin) 的基础配置
          "window.titleBarStyle" = "custom";
          "files.autoSave" = "onFocusChange";
        };
      };

    };
  };
}
