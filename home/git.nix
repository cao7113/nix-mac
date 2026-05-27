{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{

  # GIT_TRACE=1 GIT_CURL_VERBOSE=1 git pull

  ## Git config, man 1 git-config
  programs.git = {
    enable = true;

    # package = pkgs.git;

    settings = {
      user = {
        name = "Ryn Cao";
        # todo use sops
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

    # # 3. 忽略文件 (Global Gitignore)
    # ignores = [
    #   ".DS_Store" # macOS 特产
    #   "*.swp" # Vim 临时文件
    #   ".direnv/" # Nix direnv 环境
    #   "node_modules/" # 前端残留
    #   "result" # Nix 构建结果
    #   # ".vscode/" # VSCode 配置文件
    # ];

    # 4. 属性设置 (Attributes)
    # attributes = [
    #   "*.pdf diff=astextplain" # 尝试以文本形式对比 PDF (配合相关工具)
    # ];

    # LFS 支持
    # 开启这个选项后，Home Manager 会自动配置 [filter "lfs"] 段落
    lfs.enable = true;

  };

  # Git help
  # git help -a
  # git help -g
  # git help everyday
  programs.zsh.initContent = ''
    function git_current_branch() {
      git rev-parse --abbrev-ref HEAD 2> /dev/null
    }

    function gci(){
      git commit -m "$*"
    }

    function qci(){
    	git add . && git commit -m "$*"
    }

    alias glog="git-log"
    function git-log() {
      # 1. 修复 Bash/Zsh 的默认值语法错误
      local num=50
      
      # 2. 优化 date 格式：
      # %m-%d: 月-日
      # %H:%M: 时:分
      # %a: 缩写的星期几 (Wed, Thu 等)
      git log -$num \
        --graph \
        --date=format:"%m-%d %H:%M" \
        --pretty=format:"[%Cred%h%Creset]: %Cgreen%s%Creset %Cblue%an%Creset %cr %ad"
    }

    function git-pull-full(){
      git fetch --unshallow
      # git fetch --depth=2147483647
    }

    function git-track-all-branches(){
      # 1. 修改 Git 配置，让它允许追踪远程的所有分支（而不仅仅是当前这一个）
      git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    }


    function unstaged(){
      git restore --staged .
    }

    alias gcl="git clone"
    alias gcld='git clone --depth 5'
    alias gclr="git clone --recurse-submodules"

    # git命令存储路径
    alias gpath="git --exec-path"
    alias gbra='gbr -a'
    alias gbrd='gbr -d'
    # 列出远端仓库
    alias grv="git remote -v"
    # 在当前ａ分支查看ｂ分支下的文件ｃ: git show b:path/to/c
    alias gshow='git show'
    alias gcat="git cat-file -p"
    alias gstash="git stash"
    # git show-ref #查看各branch的commit id

    # https://askubuntu.com/questions/336907/really-verbose-way-to-test-git-connection-over-ssh
    #alias gpull='GIT_SSH_COMMAND="ssh -vvv" git pull'
    alias gpl='GIT_SSH_COMMAND="ssh -v" git pull'
    alias gpltags='git pull --tags'
    alias gps='GIT_SSH_COMMAND="ssh -v" git push'
    alias greset='git reset'
    alias ghreset='git add . && git reset --hard HEAD'

    # 清理远端已经不存在的本地陈旧tag
    gclean_stale_tags(){
      git tag -l | xargs git tag -d && git fetch -t
    }
    alias gdif="git diff"
    alias gdifc="gdif --cached"
    alias gdif2="git diff HEAD~1"

    # 查看引用(eg. master)的commitid
    function git-commit-id(){
    	if [ $# -lt 1 ]; then
    	  git rev-parse HEAD
    	else
        git rev-parse "$@"
    	fi
    }

    function gcleantrace(){
      remote=${"1:-origin"}
      git remote prune $remote
    }
  '';

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
