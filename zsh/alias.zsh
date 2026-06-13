# see all aliases with `alias`
# NOTE: this file loaded before checkout profile, maybe overwrite
# - keep this simple and MINI!

alias e="exit"
alias l="ls -lah"
alias cmd="command"
alias has="type -a"
alias what="which -a" # whence -a
alias fun="whence -f" # functions xxx
alias opts="getopt"

# 检测 zoxide 是否存在
if command -v zoxide >/dev/null 2>&1; then
    # 如果存在，初始化 zoxide 并将别名设为 j
    eval "$(zoxide init zsh --cmd j)"
else
    # 否则降级使用传统的 cd
    alias j="cd"
fi

# alias c="clear" # use Ctrl+l instead

# r # builtin r for repeat, Great!!! 
# r git
# dirs -v

# 语法：alias -s 后缀=程序
# alias -s {md,txt}=vim
# alias -s {html,com}=open  # 在 macOS 上
# # 以后在终端输入：
# script.py    # 自动执行 python3 script.py
# README.md    # 自动执行 vim README.md
# google.com   # 自动在浏览器打开网页

# 缩写常用管道
alias -g G='| grep -i'
alias -g L='| less'
alias -g H='| head -n 20'
alias -g CP='| pbcopy' # macOS 剪贴板
# # 使用方式：
# cat log.txt G "error" L
# ls -R H
# cat config.json CP
