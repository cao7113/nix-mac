{
  pkgs,
  config,
  lib,
  username,
  inputs,
  ...
}:
{
  home-manager.users.${username} = {
    # 开启 direnv 并启用 Zsh 集成, 自动进入 devShell 的利器
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      # https://github.com/nix-community/nix-direnv
      nix-direnv.enable = true; # 强烈建议同时开启这个，让 direnv 支持 Nix 速度起飞
      # config.global.hide_env_diff = true;
    };

    programs.zsh.initContent = ''
      export DIRENV_WARN_TIMEOUT=30s
    '';
  };
}
