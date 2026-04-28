{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{

  # 使用系统级的 nixpkgs 实例
  home-manager.useGlobalPkgs = true;
  # installed to /etc/profiles/per-user/$USERNAME if below true
  home-manager.useUserPackages = true;
  # fail if existed by default
  home-manager.backupFileExtension = "bak";

  home-manager.verbose = true;

  home-manager.users.${username} = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "25.11";

    # 启用 Home Manager 自己管理自己
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = username;
    home.homeDirectory = "/Users/${username}";

    ## docs & manual
    manual = {
      # home-manager-help tool
      html.enable = true;
      # man home-configuration.nix
      manpages.enable = true;
      json.enable = true;
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    # or
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    # or
    #  /etc/profiles/per-user/rj/etc/profile.d/hm-session-vars.sh
    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # todo manage lauch-agent

    imports = [
      ./shell.nix
      ./git.nix
      ./pkgs.nix
      ./dotfiles.nix
      # ./fortune-word.nix
      ./vim.nix
      ./mise/default.nix
      # dev/golang.nix
      ./_sec.nix
    ];
  };

}
