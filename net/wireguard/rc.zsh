# wireguard wg wrapper

function wg2() {
	local act=$1
	(($# > 0)) && shift

	local this_script="${${(%):-%x}}"
	local this_dir=${this_script:A:h}

	# /etc/wireguard/INTERFACE.conf
	local conf_home=~/.config/wireguard
	mkdir -p $conf_home

	case "$act" in
	st)
		sudo wg show
		;;
	l | ls)
		echo $conf_home
		ls -l $conf_home
		;;
	up | down)
		# note: conflict with sing-box tun-mode!

		local conf_file=$conf_home/$1.conf
		[[ -f $conf_file ]] || {
			echo "Not found config file: $conf_file" >&2
			return
		}
		echo "Using wg conf: $conf_file"
		sudo wg-quick $act $conf_file
		# sudo wg-quick up ./wg.conf
		sudo wg show
		;;
	conf)
		sudo wg showconf "$@"
		# sudo wg showconf utun5
		;;
	cat)
		local conf_file=$conf_home/$1.conf
		[[ -f $conf_file ]] || {
			echo "Not found config file: $conf_file" >&2
			return
		}
		cat $conf_file
		;;
	vi)
		vi $this_script
		;;
	j)
		cd $this_dir
		;;
	what)
		type -f wg2
		;;
	*)
		wg "$act" "$@"
		;;
	esac
}
