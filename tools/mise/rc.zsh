# Notice: mise alreay is a shell-functon and command, so here we named it m

function m() {
	local act=$1
	(($# > 0)) && shift

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
	*)
		mise $act "$@"
		;;
	esac
}
