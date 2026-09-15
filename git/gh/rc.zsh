# gh helpers
alias ghcmd="command gh"
alias gist="gh gist"

function gh() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case "$act" in
	ai)
		ghcmd copilot
		;;
	cl | clone)
		# 好处：会带着上游upstream信息
		ghcmd repo clone "$@"
		;;
	remote)
		gh-remoter "$@"
		;;
	user)
		gh-user "$@"
		;;
	verify)
		ssh -T github.com
		;;
	vis)
		# public or private visibility
		ghcmd repo view --json visibility --jq .visibility
		;;
	j)
		cd $this_dir
		;;
	vi)
		vi $this_rc
		;;
	*)
		# 其他 gh 子命令正常调用
		ghcmd $act "$@"
		;;
	esac
}
