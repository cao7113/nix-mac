{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.gh = {
    enable = true;

    # 自动生成 ~/.config/gh/config.yml
    settings = {
      prompt = "enabled";
      git_protocol = "ssh"; # https
      editor = "vim";

      aliases = {
        ls = "repo list";
        rename = "repo rename";
        a = "alias";
        al = "alias list";
        login = "auth login";
        logout = "auth logout";
        sec = "secret";
        # gh ssh list
        ssh = "ssh-key";
        pco = "pr checkout";
        pv = "pr view";
        pl = "pr list";
        pw = "pr view --web"; # 同样，参数会自动附加在后面
        ps = "pr status";
        rel = "release";
      };

    };
    # 自动安装常用的扩展
    extensions = [
      pkgs.gh-dash # 炫酷的终端仪表盘
      pkgs.gh-eco # 浏览 GitHub 社区生态
    ];
  };

  # programs.zsh.initContent = ''
  # '';

  # home.shellAliases = {
  #   gist = "gh gist";
  # };

  # home.packages = [
  #   # 使用 writeShellScriptBin 构建一个独立的 CLI 命令
  #   (pkgs.writeShellScriptBin "xxx" ''
  #   '')
  # ];
}
