## DeterminateSystem rc helpers

function nix-daemon() {
	local act=$1
	(($# > 0)) && shift

	local plist_file=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
	local plabel=org.nixos.nix-daemon.plis
	local log_file=/var/log/nix-daemon.log

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
