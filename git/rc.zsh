# Git helpers
alias g=git-wrapper

function git-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case "$act" in
	test)
		cd "$(ops home)/test-git"
		;;
	ci)
		gci "$@"
		;;
	cci)
		cci "$@"
		;;
	t | tag)
		git-tag "$@"
		;;
	b | br)
		git-branch "$@"
		;;
	r | rmt)
		git-remote "$@"
		;;
	j.cog)
		cog-wrapper j
		;;
	omz)
		# "ohmyzsh/ohmyzsh path:plugins/git" # 引入 OMZ 的 git 插件（提供 gco 等大量别名）
		open "https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh#L322"
		# 定义了 alias g
		echo "todo now overwrite them as own need"
		;;
	j)
		cd $this_dir
		;;
	home)
		echo "$this_dir"
		;;
	vi)
		vi $this_rc
		;;
	*)
		git $act "$@"
		;;
	esac
}

source "$(git-wrapper home)/aliases.zsh"
source "$(git-wrapper home)/gh/rc.zsh"
source "$(git-wrapper home)/cog/rc.zsh"
source "$(git-wrapper home)/repo/rc.zsh"

function git_current_branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}
# 查看引用(eg. master)的commitid
function git-commit-id() {
	if [ $# -lt 1 ]; then
		git rev-parse HEAD
	else
		git rev-parse "$@"
	fi
}

# use cog commit instead!!!
function gci() {
	git commit -m "$*"
}

function cci() {
	cog commit "$@"
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

function unstaged() {
	git restore --staged .
}

# 清理远端已经不存在的本地陈旧tag
function gclean_stale_tags() {
	git tag -l | xargs git tag -d && git fetch -t
}
