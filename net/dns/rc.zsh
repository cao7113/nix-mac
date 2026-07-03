# dns helper

function dns() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${${(%):-%x}}"
	local this_dir=${this_script:A:h}

	case "$act" in
	l | ls)
		scutil --dns
		;;
	c | clear | clear-cache)
		dns-clear-cache "$@"
		;;

	vi)
		vi $this_script
		;;
	j)
		cd $this_dir
		;;
	*)
		type -f dns
		;;
	esac
}

function routes() {
	netstat -nr
}

function dns-clear-cache() {
	sudo killall -HUP mDNSResponder
	sudo dscacheutil -flushcache
}

function wifi() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${${(%):-%x}}"
	local this_dir=${this_script:A:h}

	case "$act" in
	dns)
		networksetup -getdnsservers Wi-Fi
		;;
	set-dns)
		sudo networksetup -setdnsservers Wi-Fi "$@"
		;;
	reset-dns)
		sudo networksetup -setdnsservers Wi-Fi empty # "Empty"
		;;

	vi)
		vi $this_script
		;;
	j)
		cd $this_dir
		;;
	*)
		type -f wifi
		;;
	esac
}
