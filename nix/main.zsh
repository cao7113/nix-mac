echo "# nix main loading..."

function nix-daemon-reload() {
	sudo launchctl bootout system /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
	sudo launchctl bootstrap system /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
}

function nix-plist() {
	(
		set -x
		cat /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
	)
}
