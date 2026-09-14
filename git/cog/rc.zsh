alias gcog=cog-wrapper

function cog-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	# cog bump --dry-run --auto
	# cog -v get-version --fallback 0.1.0 --tag

	case "$act" in
	repo)
		open https://github.com/cocogitto/cocogitto
		;;
	ci)
		cog commit "$@"
		;;
	g)
		cog --config $this_dir/config.toml "$@"
		;;
	*)
		cog $act "$@"
		;;
	esac
}
