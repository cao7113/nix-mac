# Notice: mise alreay is a shell-functon and command, so here we named it m

function ms() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case $act in
	l)
		mise list "$@"
		;;
	rg)
		mise registry "$@"
		;;
	remote)
		mise ls-remote "$@"
		;;
	a | allow)
		# follow direnv rules
		mise trust "$@"
		;;

	fun | what)
		type -f ${funcstack[1]}
		;;
	conf | global-conf)
		vi $this_dir/config.toml
		;;
	*)
		mise $act "$@"
		# mise v
		;;
	esac
}
