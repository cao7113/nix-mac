{
  config,
  pkgs,
  lib,
  username,
  repo_path,
  ...
}:
{
  # time zsh -i -c exit

  programs.zsh = {
    enable = true;
    enableCompletion = true; # 开启 Zsh 强大的 Tab 自动补全
    autosuggestion.enable = true; # 开启命令自动建议（灰色文字提示）
    syntaxHighlighting.enable = true; # 命令行语法高亮

    shellAliases = {
      ns = "nh search";
      # osup = "nh os switch"; # 对应 darwin-rebuild switch

      e = "exit";
      t = "task";

      # 替代原生命令
      l = "eza -lah";
      # ls = "eza --icons";
      # ll = "eza -lh --icons --git";
      # la = "eza -lah --icons --git";
      # cd = "z"; # 让 cd 命令实际调用 zoxide
      j = "z";
      cat = "bat";

      # 效率工具
      g = "git";

      # Docker
      dk = "docker";
      dkc = "docker-compose";
      dki = "docker images";
      dka = "docker ps -a";

      # 极客清理：按照你的要求判断并备份/删除旧的 .zshrc
      # 使用了 Zsh 的 [[ -L ]] 判断软链接，[[ -f ]] 判断普通文件
      nix-clean-zsh = "[[ -L ~/.zshrc ]] && rm ~/.zshrc || [[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d_%H%M%S)";
    };

    # -------------------------------------------------------------------------
    # .zshrc 内容注入 (遵循最新 Home Manager API)
    # -------------------------------------------------------------------------
    initContent = lib.mkMerge [
      # # 使用 mkBefore 确保这段代码位于 .zshrc 的最顶端
      # (lib.mkBefore ''
      #   # 它是 Powerlevel10k 的 Instant Prompt 功能，用于实现终端“秒开”
      #   if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${USER}.zsh" ]]; then
      #     source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${USER}.zsh"
      #   fi
      # '')

      ''
        # 性能：如果不想每次都扫描，可以在这里添加 profiling 逻辑
        zmodload zsh/zprof

        # 由于你使用的是 Apple Silicon (aarch64-darwin)，你可以通过以下方式进一步压榨性能：
        # 启用补全缓存
        zstyle ':completion:*' use-cache yes
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"


        export nix_mac_home="${config.home.homeDirectory}/${repo_path}";
        # zsh helpers from nix-mac
        source "$nix_mac_home/main.zsh"
      ''
    ];

    # 历史记录管理
    history = {
      size = 100; # 内存中保留的历史记录条数
      save = 200; # 磁盘上存储的历史记录条数
      path = "${config.xdg.dataHome}/zsh/history"; # 使用 XDG 标准路径存储历史文件
      ignoreDups = true; # 忽略重复的命令记录
      share = true; # 在多个打开的终端窗口间实时共享历史记录
    };

    # -------------------------------------------------------------------------
    # Antidote 插件管理 (Nix 声明式加载)
    # -------------------------------------------------------------------------
    antidote = {
      enable = true;
      plugins = [
        # "romkatv/powerlevel10k" # 极速、美观的主题提示符

        # 1. 基础补全 (最先加载)
        "zsh-users/zsh-completions"

        # 2. 功能类插件
        # "getantidote/use-omz" # 兼容层：允许只引用 OMZ 的部分功能而不加载全家桶
        # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh#L322
        "ohmyzsh/ohmyzsh path:plugins/git" # 引入 OMZ 的 git 插件（提供 gst, gco 等大量别名）
        "ohmyzsh/ohmyzsh path:plugins/extract" # 一个 'extract' 命令解压所有格式
        "ohmyzsh/ohmyzsh path:plugins/sudo" # 按两次 Esc 自动加 sudo

        # 3. 效率类 (中层加载)
        "zsh-users/zsh-autosuggestions"
        # "belak/zsh-utils path:editor" # 基础编辑器增强

        # 4. 交互增强 (最后加载，确保高亮不被覆盖) 输入命令开头后按上下键搜索历史 语法高亮 (必须放最后)
        "zsh-users/zsh-syntax-highlighting"
      ];
    };

    # plugins = [
    #   {
    #     name = "my-extra-configs";
    #     src = ./my_configs; # 指向包含 .zsh 文件的文件夹
    #     file = "extra_configs.zsh"; # 该文件夹下要 source 的文件名
    #   }
    # ];
  };

  # 既漂亮又极速的提示符
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # ==========================================================
  # Zoxide: 更智能的 cd 命令 (使用 'z' 快速跳转)
  # ==========================================================
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # 自动在 zsh 中初始化 zoxide (z 命令)
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--time-style=long-iso"
    ];
  };

  # ---------------------------------------------------------------------------
  # fzf (模糊搜索器) 配置
  # ---------------------------------------------------------------------------
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # 自动绑定 Ctrl-r (历史), Ctrl-t (文件), Alt-c (切换目录)

    # 强制 fzf 使用 fd 来扫描文件，从而支持 .gitignore 并隐藏 .git 目录
    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
    changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";

    # UI/UX 增强：设置 45% 高度、反向布局、边框，以及使用 bat 实时预览文件内容
    defaultOptions = [
      "--height 45%"
      "--layout=reverse"
      "--border"
      "--info=inline"
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };
}
