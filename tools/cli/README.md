# Cli

iTerm2 todo

```
# 实时搜索文件内容并在预览窗口显示
rg --line-number --no-heading --color=always "." | fzf --ansi --preview 'preview_script {}'

# 在你的 .zshrc 中，你可以把 rg 设置为 fzf 的默认后端，这样 Ctrl-T 找文件时会瞬间飞起：
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

# 在 .zshrc 中设置更现代的 fzf 默认参数
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color="header:italic"'

bindkey '^G' fzf-cd-widget
```

在 macOS（以及所有类 Unix 系统）中，ssh_config(5) 里面的数字 (5) 代表该文档所属的 手册页章节（Manual Section）。
这是一个非常实用的系统管理标准，用来区分“同名但功能不同”的主题。

```
man 5 ssh_config
```

percent-encoded
