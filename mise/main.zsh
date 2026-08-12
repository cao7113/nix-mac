# Notice: mise alreay is a shell-functon and command, so here we named it m

alias m="mise-wrapper"

function mise-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case $act in
	doc)
		open https://mise.jdx.dev/getting-started.html
		;;
	h)
		mise help "$@"
		;;
	l)
		mise list "$@"
		;;
	lsr | remote)
		mise ls-remote "$@"
		;;
	pre | ls.pre)
		mise ls-remote "$@" --prerelease
		;;
	reg)
		mise registry "$@"
		;;
	s | q | query)
		mise search "$@"
		;;
	gen)
		mise generate "$@"
		# mise generate config	# 超级强
		;;
	a | allow)
		# follow direnv rules
		mise trust "$@"
		;;
	up)
		mise self-update
		;;
	global | global.conf)
		vi $this_dir/config.toml
		# mise config get tools
		;;

	setup | self-install)
		echo "## Only setup mise bin"
		local bin_path=~/.local/bin/mise
		curl https://mise.run | MISE_DEBUG=1 MISE_INSTALL_SKIP_IF_EXISTS=1 MISE_INSTALL_PATH=$bin_path sh
		echo "Installed into $MISE_INSTALL_PATH"

		# reload to activate hooks
		source $this_rc
		;;
	info)
		echo "MISE_CONFIG_DIR=$MISE_CONFIG_DIR"
		# which mise
		;;

	# Already support
	# v)
	# 	mise version
	# 	;;
	home)
		echo $this_dir
		;;
	j)
		cd $this_dir
		;;
	fun | what)
		type -f ${funcstack[1]}
		;;
	vi)
		vi $this_rc
		;;
	*)
		mise $act "$@"
		# mise v
		;;
	esac
}

# mise config get tools

if command -v mise &>/dev/null; then
	# https://mise.jdx.dev/directories.html#config-mise
	# Default: ${XDG_CONFIG_HOME:-$HOME/.config}/mise
	export MISE_CONFIG_DIR=$(mise-wrapper home)

	echo "# Activating mise hooks..."
	eval "$(mise activate zsh)"
else
	echo "# Warning: Not found mise, please run: mise-wrapper setup # or m setup"
fi
