{
  pkgs,
  config,
  lib,
  username,
  inputs,
  repo_path,
  need_least,
  ...
}:
{
  # mise 更新较快，直接使用brew版本
  homebrew = {
    brews = lib.optionals (need_least "all") [
      "mise"
    ];
  };

  # 💡 注意这里的修改：后面加了 = { config, ... }:
  # 这会创建一个局部作用域，这里的 config 变成了 home-manager 专属的 config
  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/mise/config.toml" = lib.mkIf (need_least "all") {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${repo_path}/tools/mise/config.toml";
      };

      # home.file.".config/mise/config.toml".text = ''
      #   copy config.toml content here, but it will be hard to maintain, so use source instead
      # '';

      # 手动将 mise 钩子注入到 Zsh 中（替代原本的 enableZshIntegration）
      programs.zsh.initContent = lib.mkIf (need_least "all") (
        lib.mkAfter ''
          # 注入 Homebrew 安装的 mise 钩子
          echo "# Running: mise homebrew hook..."
          if command -v mise &> /dev/null; then
            eval "$(mise activate zsh)"
          fi
        ''
      );
    };
}
