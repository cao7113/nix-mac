{
  pkgs,
  config,
  lib,
  username,
  inputs,
  need_least,
  ...
}:
{
  # use main.zsh to maintain mise setup now!!!

  # mise 更新较快，直接使用brew版本
  # homebrew = {
  #   brews = [ "mise" ];
  # };

  # 这会创建一个局部作用域，这里的 config 变成了 home-manager 专属的 config
  home-manager.users.${username} =
    { config, ... }:
    {

      # home.file.".config/mise/config.toml".text = ''
      #   copy config.toml content here, but it will be hard to maintain, so use source instead
      # '';

      # 手动将 mise 钩子注入到 Zsh 中（替代原本的 enableZshIntegration）
      # programs.zsh.initContent = lib.mkAfter "";
    };
}
