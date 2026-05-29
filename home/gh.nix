{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  # gh: GitHub CLI https://cli.github.com/
  programs.zsh.initContent = ''
    alias ghcmd="command gh" 

    function gh() {
      local act=$1
      (( $# > 0 )) && shift

      case "$act" in
        vis)
          ghcmd repo view --json visibility --jq .visibility
          ;;
        cl|clone)
          gh-smart-clone "$@"
          ;;
        remote)
          gh-set-remote "$@"
          ;;
        *)
          # 其他 gh 子命令正常调用
          ghcmd "$act" "$@"
          ;;
      esac
    }

    function gh-smart-clone() {
        if [[ -z "$1" ]]; then
            echo "错误: 请输入 repo 或 owner/repo"
            return 1
        fi

        local target="$1"
        shift

        # 正则表达式解释：
        # ^[a-zA-Z0-9._-]+$  -> 纯仓库名格式（不包含斜杠 /）
        # ^[^/]+/[^/]+$      -> 标准的 owner/repo 格式（包含且仅包含一个斜杠 /）

        if [[ "$target" =~ ^[a-zA-Z0-9._-]+$ ]]; then
            # 间接调用 gh-user 函数，享受多级缓存带来的丝滑速度
            local owner
            owner=$(gh-user) || return 1
            echo "# detected gh owner: $owner"
            target="$owner/$target"
        fi
        ghcmd repo clone "$target" "$@"
    }

    function gh-user() {
        # 定义缓存文件路径
        local cache_dir="''${XDG_CACHE_HOME:-''$HOME/.cache}"
        local cache_file="$cache_dir/gh-user.cache"
        local username=""

        # 1. 优先级最高：检查环境变量 GH_USER
        if [[ -n "$GH_USER" ]]; then
            echo "$GH_USER"
            return 0
        fi

        # 2. 优先级次之：检查本地文件缓存
        if [[ -f "$cache_file" ]]; then
            username=$(cat "$cache_file" 2>/dev/null)
            if [[ -n "$username" ]]; then
                echo "$username"
                return 0
            fi
        fi

        # 3. 优先级最低：通过 API 获取
        # 确保 gh 命令存在
        if ! command -v gh &>/dev/null; then
            echo "错误: 未找到 gh 命令，请先安装 GitHub CLI" >&2
            return 1
        fi

        # 调用 API 获取用户名
        username=$(gh api user --jq '.login' 2>/dev/null)

        if [[ -n "$username" ]]; then
            # 创建缓存目录并写入缓存
            mkdir -p "$cache_dir"
            echo "$username" > "$cache_file"
            
            echo "$username"
            return 0
        else
            echo "错误: 无法获取 GitHub 用户名，请检查登录状态 (gh auth status)" >&2
            return 1
        fi
    }

  '';

  # gh auth login
  programs.gh = {
    enable = true;

    # 这里的设置会自动生成 ~/.config/gh/config.yml
    settings = {
      prompt = "enabled";
      git_protocol = "ssh"; # https
      editor = "vim"; # 默认编辑器

      aliases = {
        a = "alias";
        al = "alias list";
        login = "auth login";
        logout = "auth logout";
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

  home.shellAliases = {
    og = "gh browse"; # 快速打开当前仓库的 GitHub 页面
    gist = "gh gist"; # 直接使用 gh 创建和管理 gists
  };

  ## gh-set-remote: 一个自定义的 CLI 工具，用于在 GitHub 仓库中快速切换 origin 的 SSH 和 HTTPS URL 格式。
  home.packages = [
    # 使用 writeShellScriptBin 构建一个独立的 CLI 命令
    (pkgs.writeShellScriptBin "gh-set-remote" ''
      #!/usr/bin/env bash
      set -euo pipefail

      # 1. 验证输入参数
      TARGET_FORMAT="''${1:-}"
      if [[ "$TARGET_FORMAT" != "ssh" && "$TARGET_FORMAT" != "https" ]]; then
        echo "❌ 错误: 请指定目标格式 'ssh' 或 'https'"
        echo "用法: gh-set-remote [ssh|https]"
        exit 1
      fi

      # 2. 检查是否在 Git 工作区
      if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "❌ 错误: 当前工作目录不是一个 Git 仓库"
        exit 1
      fi

      # 3. 获取当前的 origin 地址
      CURRENT_URL=$(git remote get-url origin 2>/dev/null || true)
      if [[ -z "$CURRENT_URL" ]]; then
        echo "❌ 错误: 当前仓库没有配置名为 'origin' 的远程地址"
        exit 1
      fi

      # 4. 解析 GitHub 地址中的 用户名 和 仓库名
      # 兼容 https://github.com/owner/repo.git 和 git@github.com:owner/repo.git
      if [[ "$CURRENT_URL" =~ github\.com[:/]([^/]+)/(.+) ]]; then
        OWNER="''${BASH_REMATCH[1]}"
        REPO="''${BASH_REMATCH[2]}"
        
        # 确保仓库名带有 .git 后缀
        if [[ ! "$REPO" =~ \.git$ ]]; then
          REPO="''${REPO}.git"
        fi
      else
        echo "❌ 错误: 当前 remote URL ($CURRENT_URL) 不属于 GitHub 仓库，无法转换"
        exit 1
      fi

      # 5. 根据目标格式构建新的 URL
      if [[ "$TARGET_FORMAT" == "ssh" ]]; then
        NEW_URL="git@github.com:''${OWNER}/''${REPO}"
      else
        NEW_URL="https://github.com/''${OWNER}/''${REPO}"
      fi

      # 6. 判断新旧地址是否一致，避免无意义的操作
      if [[ "$CURRENT_URL" == "$NEW_URL" ]]; then
        echo "ℹ️ 当前 remote 已经是 $TARGET_FORMAT 格式，无需修改。"
        exit 0
      fi

      # 7. 执行转换
      echo "🔄 正在切换 remote 'origin' 的协议格式..."
      echo "   - 旧地址: $CURRENT_URL"
      echo "   - 新地址: $NEW_URL"

      git remote set-url origin "$NEW_URL"
      echo "✅ 转换成功！"
    '')
  ];
}
