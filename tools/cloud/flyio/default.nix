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
    home.packages = with pkgs; [
      flyctl
    ];

    programs.zsh.initContent = lib.mkMerge [
      (lib.mkAfter (builtins.readFile ./rc.zsh))

      (lib.mkAfter ''
        # load flyctl completion
        source <(flyctl completion zsh)
      '')
    ];

    programs.zsh.shellAliases = {
      fl = "fly";
      flc = "flyctl";
    };
  };

}
