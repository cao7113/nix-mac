{
  pkgs,
  config,
  lib,
  username,
  inputs,
  ...
}:
{
  # https://devenv.sh/getting-started/#2-install-devenv
  home-manager.users.${username} = {
    ## Setup
    # todo or as a flake input to use latest version?
    # home.packages = [
    #   pkgs.devenv
    # ];
    ## Now use: nix profile add nixpkgs#devenv

    programs.zsh.initContent = ''
      # todo use direnv or this?
      # eval "$(devenv hook zsh)";
    '';
  };
}
