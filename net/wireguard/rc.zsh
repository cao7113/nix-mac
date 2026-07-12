# wireguard wg wrapper
alias w2="wg-wrapper"

function wg-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${${(%):-%x}}"
	local this_dir=${this_script:A:h}

	# /usr/local/etc/wireguard/INTERFACE.conf
	local conf_home=/usr/local/etc/wireguard
	[[ ! -d $conf_home ]] && sudo mkdir -p $conf_home

	case "$act" in
	l | ls)
		echo $conf_home
		ls -l $conf_home
		;;
	st)
		sudo wg show
		;;
	up | on)
		# note: conflict with sing-box tun-mode!
		if (($# == 0)); then
			echo "Error: require config file-name, eg. fly-vpn" >&2
			return 1
		fi

		local conf_file=$conf_home/$1.conf
		[[ -f $conf_file ]] || {
			echo "Not found config file: $conf_file" >&2
			return
		}
		echo "Using wg conf: $conf_file"
		sudo wg-quick up $conf_file
		sudo wg show
		;;
	down)
		if (($# == 0)); then
			echo "Error: require config file-name, eg. fly-vpn" >&2
			return 1
		fi

		local conf_file=$conf_home/$1.conf
		[[ -f $conf_file ]] || {
			echo "Not found config file: $conf_file" >&2
			return
		}
		echo "Using wg config: $conf_file"
		sudo wg-quick down $conf_file
		sudo wg show
		;;
	ifname)
		sudo wg show | grep 'interface:' | awk '{print $2}'
		;;
	cat)
		local conf_file=$conf_home/$1.conf
		[[ -f $conf_file ]] || {
			echo "Not found config file: $conf_file" >&2
			return
		}
		cat $conf_file
		;;
	conf)
		local iface=${1:-utun5}
		sudo wg showconf "$iface"
		;;
	conf-home)
		echo $conf_home
		;;
	vi)
		vi $this_script
		;;
	j)
		cd $this_dir
		;;
	what)
		type -f ${funcstack[1]}
		;;
	*)
		wg "$act" "$@"
		;;
	esac
}
