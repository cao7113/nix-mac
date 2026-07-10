# command fly is soft link to flyctl, ll /opt/homebrew/Cellar/flyctl/*/bin

alias flycmd="command fly"
alias fl="fly"

function fly() {
	local act=${1}
	(($# > 0)) && shift

	local this_script="${(%):-%x}"
	local this_dir=${this_script:h}

	local wg_config=~/.config/wireguard/flyio.conf

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
	j | cd)
		cd $this_dir
		;;
	vi)
		vi $this_script
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
	vpn | wg-vpn)
		# WireGuard VPN config
		local region=${1:-nrt}
		if [[ -f $wg_config ]]; then
			echo "found wg conf file: $wg_config"
		else
			mkdir -p $(dirname $wg_config)
			# fly wireguard create [your-org] [region] [peer-name]
			fly wg create personal $region wg-vpn $wg_config
		fi
		ls -l $wg_config
		echo "Hint: wg2 up flyio"
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
			dig +short aaaa wg-vpn._peer.internal @$dns
		)
		;;
	ping)
		if (($# < 1)); then
			echo "Require apo name" >&2
			return 1
		fi
		ping6 ${1}.internal
		;;
	what)
		type -f fly
		;;
	*)
		flycmd $act $@
		;;
	esac
}

# load flyctl completion
source <(flyctl completion zsh)
