# Nix rc helpers
# echo "# nix main loading..."

alias n=nix
alias np="nix-profile"
alias nixcmd="command nix"
alias nixrgcmd="nixcmd registry"
alias nixflakecmd="nixcmd flake"
alias nixprofilecmd="nixcmd profile"

local nix_rc_script="${(%):-%x}"
local nix_rc_dir=${nix_rc_script:h}

# current used installer
source $nix_rc_dir/installer/official-installer/rc.zsh

function nix() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:A:h}

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
	ps)
		sudo launchctl list | grep nix
		;;
	lab)
		cd $this_dir/lab/"$@"
		;;
	conf | config)
		# 获取当前的nix 配置
		nixcmd config show
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
		# nixcmd --offline run "$@"
		;;
	fl)
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
	store-size)
		du -hs /nix/store
		;;
	log)
		nix-daemon log
		;;
	gc | clean-store)
		nix-collect-garbage -d
		;;
	cache)
		du -sh ~/.cache/nix
		sudo du -sh /var/root/.cache/nix
		;;
	clear-cache)
		rm -fr ~/.cache/nix
		sudo rm -fr /var/root/.cache/nix
		;;
	up)
		# 🌟 绝杀命令：强制让本地的 flake.lock 重新根据你当前的纯净注册表进行解算
		# 这会把上游带过来的奇奇怪怪的海外缓存映射彻底洗掉，完全对齐到国内
		nix flake update --offline || nix flake update
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
	i | install)
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
	which | ref)
		nixrgcmd resolve "$@"
		;;
	*)
		nixrgcmd $act "$@"
		;;
	esac
}

# nix store ping --verbose

# 禁用对特定命令的路径扩展（推荐方案）
# noglob nix run nixpkgs#cowsay -- "Hello"
# nix run nixpkgs\#cowsay -- "Hello"
# nix run "nixpkgs#cowsay" -- "Hello"

# support old stype commands
# export NIX_PATH=$nix_rc_dir/_local
