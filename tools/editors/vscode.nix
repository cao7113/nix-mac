{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # 使用homebrew安装vscode，与Spotlight结合很好
  # 关联github账号并使用Setting Sync同步
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # 自动清理未在配置中声明的物理 Homebrew 包

    casks = [
      "visual-studio-code" # 声明安装官方 VS Code
    ];
  };

  # user settings: ~/Library/Application\ Support/Code/User

  # 重置清理
  # 关闭Settings Sync
  # # 删除配置文件、全局设置和缓存
  # rm -rf ~/Library/Application\ Support/Code
  # rm -rf ~/Library/Caches/com.microsoft.VSCode
  # rm -rf ~/Library/Caches/com.microsoft.VSCode.ShipIt
  # rm -rf ~/.vscode*
  # # 如果你使用的是 VS Code Insiders 版本，运行这两行：
  # rm -rf ~/Library/Application\ Support/Code\ -\ Insiders
  # rm -rf ~/.vscode-insiders

  # 2026.5试用后慎重评估如下：
  # - 不建议使用hm的programs.vscode安装配置vscode（变成只读版本，实际配置和使用不方便）
  # - Keep simple and easy!

  # nix-darwin + home-manager下管理 VS Code 安装和配置
  # https://github.com/nix-community/home-manager/blob/release-26.05/modules/programs/vscode/default.nix
  # 保允许非开源软件（VS Code 插件和本体需要）
  # nixpkgs.config.allowUnfree = true;

  # 声明式隔离的 Profiles
  # 当执行 darwin-rebuild switch 后，Nix 会在 ~/Library/Application Support/Code/User/profiles/ 下建立好 elixir 和 nix 的配置软链接。
  # 最后一步，进入你不同的项目仓库，在根目录下建立 .vscode/settings.json 来绑定对应的 Profile：
  # // <elixir-project-root>/.vscode/settings.json
  # {
  #   "workbench.profiles.actions.profileToUse": "elixir"
  # }
  # home-manager.users.${username} = {
  #  # https://home-manager-options.extranix.com/?query=vscode&release=release-26.05
  #  # ls -l ~/Applications/Home\ Manager\ Apps/'Visual Studio Code.app'
  #  # Spotlight可搜素到
  #  programs.vscode = {
  #    enable = true;
  #  };
  # };
}
