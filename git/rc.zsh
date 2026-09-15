# Git helpers
alias g=git-wrapper

function git-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case "$act" in
	t | test)
		cd "$(ops home)/test-git"
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

function gci() {
	git commit -m "$*"
}

function qci() {
	git add . && git commit -m "$*"
}

function lclone() {
	(
		mkdir -p _local
		cd _local
		git clone --depth 1 "$@"
	)
}

function git-tag() {
	local act=$1
	(($# > 0)) && shift

	# local this_rc="${(%):-%x}"
	# local this_dir=${this_rc:A:h}

	case "$act" in
	l | ls | list)
		git tag
		# git tag -l "v1.*"
		# 查看包含特定 Commit 的 Tag（排查某个 Bug 在哪个版本包含）
		# git tag --contains <commit_hash>
		;;
	del | rm)
		git tag -d "$@"
		;;
	bump)
		# todo 本地根据 convertional commits bump version and tag
		;;
	mk | create)
		git tag "$@"
		# # 基于当前分支最新的 Commit 创建
		# git tag v1.0.0-light
		# # 基于历史某个 Commit 创建
		# git tag v0.9.0 9fceb02
		;;
	a)
		# annotated tag: git tag -a v0.1.0 -m "xxx"
		if (($# == 0)); then
			echo "Require tag_name"
			type -f ${funcstack[1]}
			return 1
		fi
		local tag_name="$1"
		shift

		git tag -a "$tag_name" "$@"
		;;

	show)
		git show "$@"
		# gh release view v0.1.0
		;;
	# force)
	# 	git tag -f <tag_name> [commit_id]` *(强制覆盖本地)
	#   git push origin -f <tag_name>` *(强制覆盖远程)*
	# 	;;
	r | remote)
		git-tag-remote "$@"
		;;

	fun)
		type -f ${funcstack[1]}
		;;
	*)
		git tag $act "$@"
		;;
	esac
}

function git-tag-remote() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	l | ls)
		# gh release list
		local remote="${1:-origin}"
		git ls-remote --tags ${remote}
		;;
	rm | del)
		# gh release delete <tag_name> --cleanup-tag
		local tag="$1"
		local remote="${2:-origin}"
		git push ${remote} --delete $tag
		;;
	ps | push)
		local tag="$1"
		local remote="${2:-origin}"
		git push "$remote" "$tag"
		;;
	psa | push.all)
		local remote="${1:-origin}"
		git push "$remote" --tags
		;;
	pl | pull)
		local remote="${1:-origin}"
		git fetch "$remote" --tags
		;;
	pull.tag)
		local tag="$1"
		local remote="${2:-origin}"
		git fetch "$remote" "refs/tags/$tag:refs/tags/$tag"
		;;
	esac
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

# 清理远端已经不存在的本地陈旧tag
function gclean_stale_tags() {
	git tag -l | xargs git tag -d && git fetch -t
}

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
