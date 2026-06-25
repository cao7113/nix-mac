## Proxy helpers

alias p="proxy"
function proxy() {
	local act=$1
	(($# > 0)) && shift

	local host=$(proxy-cache PROXY_HOST)
	local port=$(proxy-cache PROXY_PORT)
	local socks_port=$(proxy-cache PROXY_SOCKS_PORT)

	case "$act" in
	on | set)
		export http_proxy="http://$host:$port"
		export https_proxy="http://$host:$port"
		export all_proxy="socks5h://$host:$socks_port"
		export no_proxy="localhost,127.0.0.1,local,.local"

		proxy info
		;;
	off | unset)
		unset http_proxy
		unset https_proxy
		unset all_proxy
		unset no_proxy
		proxy info
		;;
	t | test)
		curl -v https://www.google.com
		;;
	conf | cache)
		proxy-cache "$@"
		;;
	*)
		echo "# Current proxy"
		echo "export http_proxy=$http_proxy"
		echo "export https_proxy=$https_proxy"
		echo "export all_proxy=$all_proxy"
		echo "export no_proxy=$no_proxy"
		;;
	esac
}

function proxy-cache() {
	if (($# == 0)); then
		# type -f proxy-cache
		cat <<-EOF
			Usage:
			proxy-cache PROXY_HOST                  
			proxy-cache PROXY_HOST 192.168.0.1
		EOF
		return
	fi

	local valid_names=(PROXY_HOST PROXY_PORT PROXY_SOCKS_PORT)
	if [[ -z "${valid_names[(r)$1]}" ]]; then
		echo "Invalid name: $1, should in ${valid_names[@]}" >&2
		return 1
	fi

	local cache_dir="${HOME}/.nix-proxy-cache"
	local file=$cache_dir/$1
	if [[ -f $file ]]; then
		cat $file
		return
	else
		echo "Not found file: $file, please first set" >&2
		return 1
	fi

	echo -n "$2" >$file
	echo "Written $2 to $file" >&2
}

function sudop() {
	local host=$(proxy-cache PROXY_HOST)
	local port=$(proxy-cache PROXY_PORT)
	local socks_port=$(proxy-cache PROXY_SOCKS_PORT)
	if (($# == 0)); then
		echo "sudo http_proxy=http://$host:$port https_proxy=http://$host:$port all_proxy=socks5h://$host:$socks_port"
	else
		sudo http_proxy=http://$host:$port https_proxy=http://$host:$port all_proxy=socks5h://$host:$socks_port "$@"
	fi
}
