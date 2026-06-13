alias mac=nix-mac
alias mup="mac up"
alias iup="mac iup"
alias machm=nix-mac-home-manager
alias np="nix-profile"

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
		sudo darwin-rebuild switch --flake $this_dir --verbose --impure
		;;
	up | use)
		sudo darwin-rebuild switch --flake $this_dir --verbose
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

# The home-manager switch command performs a combined build and activation.
function nix-mac-home-manager() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:A:h}

	case $act in
	j | cd)
		cd $this_dir
		;;
	h | help | docs)
		home-manager-help
		;;
	man | manual-local)
		man home-configuration.nix
		;;
	bins)
		ls -l /etc/profiles/per-user/$(whoami)/bin/
		;;
	repo)
		open https://github.com/nix-community/home-manager
		;;
	v)
		nix-flake metadata --json | jq -r '.locks.nodes."home-manager".locked.rev'
		;;
	session-vars)
		less ~/.nix-profile/etc/profile.d/hm-session-vars.sh
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

DSH_PROFILE_ID="dummy" source "$nix_mac_home/zsh/main.zsh"
source $nix_mac_home/nix/main.zsh
source $nix_mac_home/darwin/main.zsh
source $nix_mac_home/tools/main.zsh
# todo put other place
source $nix_mac_home/home/git.zsh

dot_sec_home=~/.sec
if [[ -d $dot_sec_home ]]; then
	export dot_sec_home

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

# 允许 # 出现
setopt interactive_comments


## Nix helpers

# nixhome="${${(%):-%x}:h}"
alias n=nix
alias nj="nix j"
alias np="nix-profile"

alias nixcmd="command nix"
alias nixrgcmd="nixcmd registry"
alias nixflakecmd="nixcmd flake"
alias nixprofilecmd="nixcmd profile"

nix_rc_script="${(%):-%x}"
nix_rc_dir=${nix_rc_script:A:h}

# support old stype commands
export NIX_PATH=$nix_rc_dir/_local

# 禁用对特定命令的路径扩展（推荐方案）
alias nix='noglob nix' # nix run nixpkgs#cowsay
# nix run nixpkgs\#cowsay -- "Hello"
# nix run "nixpkgs#cowsay" -- "Hello"

function nix() {
	local act=$1
	(($# > 0)) && shift

	local this_script="$nix_rc_script"
	local this_dir=${this_script:A:h}

	# todo take --debug

	case $act in
	j | cd)
		cd $this_dir
		;;
	h | man | doc)
		open https://nix.dev/reference/nix-manual
		;;
	help)
		nixcmd --help "$@"
		;;
	i | info)
		echo "this_script=$this_script"
		echo "this_dir=$this_dir"
		;;
	# log)
	# 	# tail -n 100 -f /var/log/determinate-nix-daemon.log
	# 	# tail -n 100 -f /var/log/nix.log
	# 	;;
	
	ps)
		sudo launchctl list | grep nix
		;;
	lab)
		cd $this_dir/lab/"$@"
		;;
	d | dev)
		nixcmd develop "$@"
		;;
	dm)
		nix-daemon "$@"
		;;
	sh)
		# noglob to escape #
		# noglob nix shell nixpkgs#htop -c htop
		nixcmd shell "$@"
		;;
	b)
		nixcmd build "$@"
		;;
	r)
		nixcmd run "$@"
		;;
	or | off-r | off-run)
		nixcmd --offline run "$@"
		;;
	f | fl)
		nix-flake "$@"
		;;
	rg)
		nix-registry "$@"
		;;
	p)
		nix-profile "$@"
		;;
	fm | fmt)
		# nix fmt -vv "$@"
		rg --files -g "*.nix" -0 | xargs -0 nixfmt
		;;
	st | store)
		du -hs /nix/store
		;;
	store-nix)
		ls -ld /nix/store/*-nix-*
		;;
	gc | clean-store)
		nix-collect-garbage -d
		;;
	v)
		nixcmd --version
		;;
	*)
		nixcmd $act "$@"
		;;
	esac
}

function nix-profile() {
	local act=$1
	(($# > 0)) && shift

	case $act in
	l | ls)
		nixprofilecmd list "$@"
		;;
	rm | del)
		nixprofilecmd remove "$@"
		;;
	install)
		nixprofilecmd add "$@"
		;;
	up)
		nixprofilecmd upgrade "$@"
		;;
	his | info)
		nixprofilecmd history
		;;
	back)
		nixcmd profile rollback
		;;
	to)
		# nixprofilecmd switch --to "$@"
		nixprofilecmd --to "$@"
		;;
	*)
		nixprofilecmd $act "$@"
		;;
	esac
}

function nix-flake() {
	local act=$1
	(($# > 0)) && shift

	case $act in
	m | meta)
		nixflakecmd metadata "$@"
		;;
	i)
		nixflakecmd info "$@"
		;;
	s)
		nixflakecmd show "$@"
		;;
	c)
		nixflakecmd check "$@"
		;;
	*)
		nixflakecmd $act "$@"
		;;
	esac
}

function nix-registry() {
	local act=$1
	(($# > 0)) && shift

	case $act in
	l | ls)
		nixrgcmd list "$@"
		;;
	rm | del)
		nixrgcmd remove "$@"
		;;
	*)
		nixrgcmd $act "$@"
		;;
	esac
}

function nix-daemon() {
	local act=$1
	(($# > 0)) && shift

  local plist_file=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
	case $act in
	cat)
		cat $plist_file
		;;
	st)
		sudo launchctl list|grep nix
		;;
	reup)
		sudo launchctl kickstart -k system/org.nixos.nix-daemon
		;;
	log)
		tail -n 100 -f /var/log/nix-daemon.log
		;;
	log-reset)
		# sudo echo "# manual hard reset" > /var/log/nix-daemon.log
		sudo tee /var/log/nix-daemon.log < /dev/null
		;;
	*)
		ls -l $plist_file
		;;
	esac
}