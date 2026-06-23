# dot-sec link and import helpers

export dot_sec_home=${DOT_SEC_HOME:-~/.sec}

# autoload dot-sec rc
if [[ -d $dot_sec_home ]]; then
	sec_main_rc="$dot_sec_home/main.zsh"
	if [[ -f "$sec_main_rc" ]]; then
		source "$sec_main_rc"
	else
		# 仅在交互式终端中提示，避免污染非交互脚本
		if [[ $- == *i* ]]; then
			printf "\033[0;33m提示: 未检测到私密配置 (${sec_main_rc})\033[0m\n"
		fi
	fi
fi

alias sboot="dot-sec-bootstrap"
function dot-sec-bootstrap() {
	local act=${1:-info}
	(($# > 0)) && shift

	case "$act" in
	info)
		echo "dot_sec_home=$dot_sec_home"
		[[ -d $dot_sec_home ]] && {
			echo "# Already setup"
		} || {
			echo "# Not set, please use: sboot setup"
		}
		;;
	init | setup)
		local sec_repo_path=${nix_mac_home}/_local/dot-sec
		[[ -d $sec_repo_path ]] && {
			echo "Found dot-sec at $sec_repo_path"
		} || {
			(
				local gh_repo=${DOT_SEC_GH_REPO:-cao7113/dot-sec}
				mkdir -p $(dirname $sec_repo_path)
				gh repo clone $gh_repo $sec_repo_path
				ln -snf $sec_repo_path $dot_sec_home
				echo "Init set dot-sec at: $sec_repo_path and link to $dot_sec_home"
			)
		}
		;;
	esac
}
