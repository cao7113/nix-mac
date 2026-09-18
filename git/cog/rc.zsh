alias gcog=cog-wrapper

function cog-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	# cog bump --dry-run --auto
	# cog -v get-version --fallback 0.1.0 --tag
	local ref_conf=$this_dir/config.toml

	case "$act" in
	ci)
		cog commit "$@"
		;;
	demo)
		cd $this_dir/_local/demo
		;;
	repo)
		open https://github.com/cocogitto/cocogitto
		;;
	conf)
		cat $ref_conf
		;;
	g)
		cog --config $ref_conf "$@"
		;;
	j)
		cd $this_dir
		;;
	*)
		cog $act "$@"
		;;
	esac
}
