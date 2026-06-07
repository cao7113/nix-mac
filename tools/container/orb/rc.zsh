# orbstack rc helper

# alias oc="orbctl"
alias orbcmd="command orb"

function orb() {
	local act=$1
	(( $# > 0 )) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:A:h}

	case $act in
	j|cd)
		cd $this_dir
		;;
	home)
		echo $this_dir
		;;
	l|ls|m|machine)
		orbcmd list
		;;
	dk.log)
		# 实时查看 orbstack 中关于 docker 引擎的日志(OrbStack 深度集成了系统日志)
		orbcmd logs docker
		;;
	*)
		orbcmd "$act" "$@"
		;;
	esac
}

# orb proxy
# orbp() {
#   port=${1:-1086}
#   scheme=${2:-socks5h}
#   proxy=$scheme://host.internal:$port
#   cat <<-Doc
#     export http_proxy=$proxy
#     export https_proxy=$proxy
#     export HTTPS_PROXY=$proxy
#     export all_proxy=$proxy
#     export no_proxy=localhost,host.internal,localaddress,.localdomain.com
# Doc
# }