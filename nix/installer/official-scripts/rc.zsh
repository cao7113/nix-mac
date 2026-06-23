## Official install-script rc helpers

function nix-daemon() {
	local act=$1
	(($# > 0)) && shift

	local plist_file=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
	case $act in
	st)
		sudo launchctl list | grep nix
		;;
	cat)
		cat $plist_file
		;;
	vi)
		sudo vi /etc/nix/nix.conf
		# should restart daemon when config changed to reload
		nix-daemon reup
		;;
	reup)
		sudo launchctl kickstart -k system/org.nixos.nix-daemon
		;;
	log)
		tail -n 100 -f /var/log/nix-daemon.log
		;;
	log-reset)
		# sudo echo "# manual hard reset" > /var/log/nix-daemon.log
		sudo tee /var/log/nix-daemon.log </dev/null
		;;
	*)
		ls -l $plist_file
		;;
	esac
}
