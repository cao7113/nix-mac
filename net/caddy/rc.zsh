alias cad="caddy-wrapper"

function caddy-wrapper() {
	local act="$1"
	(($# > 0)) && shift

	this_rc="${${(%):-%x}}"
	this_dir=${this_rc:A:h}

	local caddy_home="/var/lib/caddy"
	local caddy_dir="$caddy_home/data/caddy"
	local local_root_cert="$caddy_dir/pki/authorities/local/root.crt"
	local conf_file=/etc/caddy/Caddyfile

	case "$act" in
	run)
		# sudo
		caddy run --watch --config ./Caddyfile
		;;
	lab)
		cd $this_dir/lab
		;;
	fs)
		caddy file-server --browse --listen :8080
		;;
	fmt)
		caddy fmt --overwrite "$@"
		;;

	i | info)
		echo "# Test with https://caddy.test.h"
		echo "caddy home: $caddy_dir"
		echo "conf file : $conf_file"
		# sudo ls -l $caddy_dir

		# curl -L http://localhost:2019/config | jq -r ".apps.pki.certificate_authorities.local.name"
		local label=$(caddy adapt --config $conf_file | jq -r ".apps.pki.certificate_authorities.local.name")
		echo "Local CA Name: $label" # Caddy Local Lab Prod CA - 2026 ECC Root
		;;
	conf)
		cat $conf_file
		;;
	certs)
		echo "root cert: $local_root_cert" # /var/lib/caddy/data/caddy/pki/authorities/local/root.crt
		sudo ls -l "$caddy_dir/certificates/local/"
		;;
	cert | root.cert)
		sudo ls -l $local_root_cert
		sudo certtool d $local_root_cert
		;;
	kc.cert)
		sudo openssl x509 -noout -fingerprint -sha1 -in $local_root_cert | sed 's/^.*=//' | tr -d ':' | kc-util cert find-by-fp
		;;
	trust)
		# 注意： trust 会从 admin api获取证书并加入本地keychain store，本身不产生证书
		# Caddy服务首次启动时自动生成local ca keys，并加入本地keychain，但没有设置信任（需要权限），需要这里明确设置，否则会不生效
		sudo caddy trust --config $conf_file
		;;
	reup)
		sudo lctl reup org.nixos.caddy
		;;
	log)
		tail -f -n 200 /var/log/caddy.*
		# sudo lctl log org.nixos.caddy
		;;
	clear | reset)
		# pkill caddy
		# sudo lctl stop org.nixos.caddy
		sudo rm -rf "$caddy_dir"
		# cad setup
		;;

	vi)
		vi $this_rc
		;;
	j)
		cd "$this_dir"
		;;
	*)
		caddy $act "$@"
		;;
	esac
}

function caddy-user() {
	local act="$1"
	(($# > 0)) && shift

	local caddy_dir="$HOME/Library/Application Support/Caddy"
	local local_root_cert="$caddy_dir/pki/authorities/local/root.crt"

	case "$act" in
	i | info)
		echo "root cert: $local_root_cert"
		echo "caddy dir: $caddy_dir"
		ls -l $caddy_dir
		;;
	clear | reset)
		# pkill caddy
		sudo rm -rf "$caddy_dir"
		;;
	esac
}
