# dns helper

# dscacheutil -q host -a name lh
# dig @127.0.0.1 lh

function dns() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${${(%):-%x}}"
	local this_dir=${this_rc:A:h}

	case "$act" in
	l | ls)
		scutil --dns
		;;
	c | clear | clear-cache)
		dns-clear-cache "$@"
		;;
	q)
		dnsmasq "$@"
		;;
	r | resolver)
		ls -al /etc/resolver/
		;;
	vi)
		vi $this_rc
		;;
	j)
		cd $this_dir
		;;
	*)
		type -f dns
		;;
	esac
}

function dns-clear-cache() {
	sudo killall -HUP mDNSResponder
	sudo dscacheutil -flushcache
}

function wifi() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${${(%):-%x}}"
	local this_dir=${this_rc:A:h}

	local name=Wi-Fi

	case "$act" in
	dns)
		networksetup -getdnsservers $name
		;;
	set-dns)
		sudo networksetup -setdnsservers $name "$@"
		;;
	reset-dns)
		sudo networksetup -setdnsservers $name empty # "Empty"
		;;

	vi)
		vi $this_rc
		;;
	j)
		cd $this_dir
		;;
	*)
		type -f ${funcstack[1]}
		;;
	esac
}

function routes() {
	netstat -nr
}
