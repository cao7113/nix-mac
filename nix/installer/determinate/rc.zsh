## DeterminateSystem rc helpers

function nix-daemon() {
	local act=$1
	(($# > 0)) && shift

	# sudo launchctl bootout system /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
	# sudo launchctl bootstrap system /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
	local plist_file=/Library/LaunchDaemons/systems.determinate.nix-daemon.plist
	local plabel=systems.determinate.nix-daemon
	local log_file=/var/log/determinate-nix-daemon.log

	case $act in
	st | ps)
		sudo launchctl list | grep nix
		;;
	cat)
		echo $plist_file
		cat $plist_file
		;;
	vi)
		sudo vi /etc/nix/nix.conf
		# should restart daemon when config changed to reload
		nix-daemon reup
		;;
	reup)
		sudo launchctl kickstart -k system/$plabel
		;;
	log)
		tail -n 100 -f $log_file
		;;
	reset-log)
		sudo tee $log_file </dev/null
		;;
	*)
		ls -l $plist_file
		;;
	esac
}
