alias repocmd="command repo"

function repo() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	# todo save into repo(.sec or chezmoi)
	# local conf_file=~/.config/repo-manager/repos.yaml
	local repo_dir=~/dev/golab/repo-manager

	case "$act" in
	j)
		cd $repo_dir
		;;
	j.rc)
		cd $this_dir
		;;
	d | dev.run)
		local local_cmd=$repo_dir/bin/repo
		echo "# Using dev: $local_cmd"
		$local_cmd "$@"
		;;
	setup)
		if ! repocmd &>/dev/null; then
			echo "not found, install by mise"
			mise use -g repo
		else
			echo "Installed"
		fi
		;;
	*)
		repocmd $act "$@"
		;;
	esac
}
