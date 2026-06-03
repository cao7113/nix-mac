# Git help
# git help -a
# git help -g
# git help everyday
# GIT_TRACE=1 GIT_CURL_VERBOSE=1 git pull

function git_current_branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function gci() {
	git commit -m "$*"
}

function qci() {
	git add . && git commit -m "$*"
}

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

function git-pull-full() {
	git fetch --unshallow
	# git fetch --depth=2147483647
}

function git-track-all-branches() {
	# 1. 修改 Git 配置，让它允许追踪远程的所有分支（而不仅仅是当前这一个）
	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
}

function unstaged() {
	git restore --staged .
}

alias gurl="git-repo-url"

alias glog="git-log"
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
gclean_stale_tags() {
	git tag -l | xargs git tag -d && git fetch -t
}
alias gdif="git diff"
alias gdifc="gdif --cached"
alias gdif2="git diff HEAD~1"

# 查看引用(eg. master)的commitid
function git-commit-id() {
	if [ $# -lt 1 ]; then
		git rev-parse HEAD
	else
		git rev-parse "$@"
	fi
}

function gcleantrace() {
	remote=${1:-origin}
	git remote prune $remote
}

# 通用 Git 远程地址转 HTTP 网页 URL 函数
function git-repo-url() {
	local remote_name="${1:-origin}" # 默认读取 origin，也可以手动指定
	local input_url=""

	# 1. 自动获取本地 Git 仓库的远程地址
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		input_url=$(git config --get "remote.${remote_name}.url")
		if [[ -z "$input_url" ]]; then
			echo "Error: 未找到名为 '${remote_name}' 的远程仓库配置。" >&2
			return 1
		fi
	else
		# 如果不在 git 仓库内，且第一个参数看起来像一个 URL，则直接处理该字符串
		if [[ "$1" == *":"* || "$1" == "http"* ]]; then
			input_url="$1"
		else
			echo "Error: 请在 Git 仓库内运行，或直接提供一个 Git URL。" >&2
			return 1
		fi
	fi

	local http_url="$input_url"

	# 2. 通用解析与清洗
	# 处理 ssh://git@host/ 格式
	if [[ "$http_url" =~ ^ssh://git@([^/]+)/(.*)$ ]]; then
		http_url="https://${match[1]}/${match[2]}"
	# 处理经典的 git@host:user/repo.git 格式
	elif [[ "$http_url" =~ ^git@([^:]+):(.*)$ ]]; then
		http_url="https://${match[1]}/${match[2]}"
	fi

	# 3. 移除末尾的 .git 后缀
	http_url="${http_url%\.git}"

	echo "$http_url"
}

# 衍生快捷命令：秒开浏览器
function gbo() {
	local url
	url=$(git-repo-url "$1") && open "$url"
	# 太慢，每次都要请求github api，尽量从本地读取！！！
	# GH_DEBUG=api gh browse -n
}
