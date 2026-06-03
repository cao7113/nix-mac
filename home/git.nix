{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  ## Git config, man 1 git-config
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Ryn Cao";
        email = "cao7113@hotmail.com";
        signingkey = "cao7113@hotmail.com";
        # commit.gpgsign = true;
      };

      # 核心运行时设置
      core = {
        autocrlf = "input"; # 自动处理换行符 (macOS/Linux 推荐)
        # git config --global core.excludesfile
        excludesfile = "${./git-ignores.txt}";
      };

      # 1. 快捷别名 (Aliases) - 极大提升效率
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        last = "log -1 HEAD";
        # 更有趣的：图形化查看分支线（漂亮且简洁）
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        unstage = "reset HEAD --";
        t = "tag";
      };

      # 基础设置
      init.defaultBranch = "main";
      push.autoSetupRemote = true; # 第一次 push 自动建立远程追踪
      pull.rebase = true; # Pull 时默认使用 rebase，保持提交历史整洁
      push.default = "simple";

      # 解决冲突相关
      merge.tool = "vimdiff"; # 或者你喜欢的 GUI 工具
      # conflictstyle = "zdiff3"; # 比默认 diff3 更清晰的冲突展示

      # 凭据管理 (macOS 专属)
      credential.helper = "osxkeychain";

      # 性能与自动维护
      gc.auto = 256; # 自动垃圾回收频率

      # 颜色与外观 (如果没用 Delta，这些也会让默认输出更好看)
      color = {
        ui = "auto";
        branch = "auto";
        diff = "auto";
        status = "auto";
      };

      # 强制启用一些安全检查
      fsck.objects = true; # 检查对象完整性

      # 格式化与应用设置
      format.pretty = "%C(yellow)%h%Creset %s %C(red)(%an, %cr)%Creset";
      apply.whitespace = "nowarn";
      tag.sort = "-v:refname";

      # HTTP 与 Cookie
      http = {
        cookiefile = "/tmp/git-cookie.txt";
        savecookies = true;
      };

      extraConfig = {
        # 第一个 helper = "" 会告诉 Git：“忘掉之前所有的凭据助手，从这一行开始重新计算。”
        "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
    };

    # 忽略文件 (Global Gitignore)
    # ignores = [
    #   ".DS_Store" # macOS 特产
    #   "result" # Nix 构建结果
    #   # ".vscode/" # VSCode 配置文件
    # ];

    # LFS 支持
    # 开启这个选项后，Home Manager 会自动配置 [filter "lfs"] 段落
    lfs.enable = true;
  };

  # 启用 Delta: 一个极佳的代码 Diff 查看器 (替代默认的 diff), 它能提供语法高亮、行号和更清晰的对比
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
