alias gco='git checkout'
alias ga='git add'
alias gst='git status'
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

alias gdif="git diff"
alias gdifc="gdif --cached"
alias gdif2="git diff HEAD~1"

## expand tools

alias gb=git-branch
alias gurl="git-repo-url"
alias glog="git-log"
alias gtag="git-tag"
alias og="gbo"
