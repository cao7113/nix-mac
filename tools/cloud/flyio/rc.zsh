# command fly finally soft-link to flyctl

alias flycmd="command fly"
alias fl="fly"
alias vpn="fly-vpn"

function fly() {
	local act=${1}
	(($# > 0)) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:h}

	case "$act" in
	st)
		flycmd status
		;;
	sh)
		flycmd ssh console
		;;
	h)
		flycmd help "$@"
		;;
	o | open)
		flycmd apps open $@
		;;
	log)
		flycmd logs $@
		;;
	sec)
		flycmd secrets $@
		;;
	restart)
		# not works?
		flycmd m restart $@
		;;
	dep)
		flycmd deploy --verbose $@
		;;
	vpn)
		fly-vpn "$@"
		;;

	j | cd)
		cd $this_dir
		;;
	vi)
		vi $this_script
		;;
	what)
		type -f fly
		;;
	*)
		flycmd $act $@
		;;
	esac
}

# VPN based-on flyio WireGuard
function fly-vpn() {
	local act=$1
	(($# > 0)) && shift

	local wg_config_home=/usr/local/etc/wireguard
	if [[ ! -d $wg_config_home ]]; then
		echo "Error: not found $wg_config_home, please setup it firstly!" >&2
		return 1
	fi

	local org=personal
	local conf_name=fly-vpn
	local peer_name=fly-vpn
	local wg_config=$wg_config_home/${conf_name}.conf

	case "$act" in
	st)
		sudo wg show
		;;
	up | down)
		wg-wrapper $act $conf_name
		;;
	setup)
		local region=${1:-nrt}
		if [[ -f $wg_config ]]; then
			echo "already setup wg conf file: $wg_config"
		else
			# fly wireguard create [your-org] [region] [peer-name]
			sudo fly wg create $org $region $peer_name $wg_config
		fi
		ls -l $wg_config
		echo "Hint: wg-wrapper up $conf_name"
		;;
	reset)
		echo "# Reseting vpn config"
		fly wg remove $org $peer_name
		sudo rm $wg_config
		fly-vpn setup
		echo "# Reset done"
		;;
	dns)
		grep -i '^DNS' $wg_config | awk -F '=' '{print $2}' | tr -d ' '
		;;
	dig)
		# https://fly.io/docs/networking/private-networking/#connect-to-the-fly-io-dns-over-wireguard
		if [[ ! -f $wg_config ]]; then
			echo "Not found $wg_config" >&2
			return 1
		fi
		local dns=$(grep -i '^DNS' $wg_config | awk -F '=' '{print $2}' | tr -d ' ')
		echo "# Using dns: $dns"
		(
			set -x
			dig +short txt _apps.internal @$dns
			local peer_name=$(dig +short txt _peer.internal @$dns)
			echo "Peer $peer_name 6pn address:"
			dig +short aaaa fly-vpn._peer.internal @$dns
		)
		;;
	ping)
		if (($# < 1)); then
			echo "Require fly-apo-name" >&2
			return 1
		fi
		ping6 ${1}.internal
		;;
	what)
		type -f ${funcstack[1]}
		;;
	*)
		echo "flyio wg config file: $wg_config"
		;;
	esac
}

# load flyctl completion
source <(flyctl completion zsh)
