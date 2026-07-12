alias mac=nix-mac
alias iup="mac iup"
alias machm=nix-mac-home-manager
alias mdp="$nix_mac_home/deploy.zsh"

function nix-mac() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:A:h}

	case $act in
	home)
		# echo $nix_mac_home
		echo $this_dir
		;;
	j | cd)
		cd $this_dir
		;;
	man | manual-local)
		darwin-help
		;;
	h | help)
		darwin-rebuild --help
		;;
	iup | impure)
		mdp up
		;;
	back)
		sudo darwin-rebuild switch --flake $this_dir --rollback
		;;
	gens | versions)
		sudo darwin-rebuild --list-generations | tail -r | head

		# # 删除除了最近几次以外的所有旧版本
		# sudo nix-env -p /nix/var/nix/profiles/System --delete-generations +10
		# # 列出所有历史版本
		# nix profile history --profile /nix/var/nix/profiles/system
		# # 回滚到上一版本
		# nix profile rollback --profile /nix/var/nix/profiles/system
		;;
	st | status | now | current)
		ls -l /nix/var/nix/profiles/System
		;;
	build)
		darwin-rebuild build --flake $this_dir
		;;
	bins | sw)
		ls -l /run/current-system/sw/bin
		;;
	tree | tui)
		nix-tree /run/current-system
		;;
	refs)
		# 查看当前系统版本（Generation）是从哪些 Nix Store 路径构建出来的，可以使用以下命令。
		# 它会列出当前系统路径下引用的所有软件包
		nix-store -q --references /run/current-system | grep -v 'darwin-system'
		;;
	v)
		darwin-version
		;;
	repo)
		open https://github.com/nix-darwin/nix-darwin
		;;
	run | do)
		darwin-rebuild --flake $this_dir "$@"
		;;
	*)
		cd $this_dir
		;;
	esac
}

# nix_mac_home exported by zsh/default.nix
if [[ -z "$nix_mac_home" ]]; then
	export nix_mac_home=$(nix-mac home)
fi

path=("${nix_mac_home}/bin" $path)

DSH_PROFILE_ID="dummy" source "$nix_mac_home/zsh/main.zsh"
source $nix_mac_home/nix/main.zsh
source $nix_mac_home/darwin/main.zsh
# todo put other place
source $nix_mac_home/home/git.zsh
source $nix_mac_home/home/dot-sec.zsh
source $nix_mac_home/net/main.zsh
source $nix_mac_home/brew/main.zsh
source $nix_mac_home/tools/main.zsh

# # The home-manager switch command performs a combined build and activation.
# function nix-mac-home-manager() {
# 	local act=$1
# 	(($# > 0)) && shift

# 	local this_script="${(%):-%x}"
# 	local this_dir=${this_script:A:h}

# 	case $act in
# 	j | cd)
# 		cd $this_dir
# 		;;
# 	h | help | docs)
# 		home-manager-help
# 		;;
# 	man | manual-local)
# 		man home-configuration.nix
# 		;;
# 	bins)
# 		ls -l /etc/profiles/per-user/$(whoami)/bin/
# 		;;
# 	repo)
# 		open https://github.com/nix-community/home-manager
# 		;;
# 	v)
# 		nix-flake metadata --json | jq -r '.locks.nodes."home-manager".locked.rev'
# 		;;
# 	session-vars)
# 		less ~/.nix-profile/etc/profile.d/hm-session-vars.sh
# 		;;
# 	*)
# 		cd $this_dir
# 		;;
# 	esac
# }
