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
	local svc_label=org.nixos.caddy

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
		caddy fmt --overwrite -c ./Caddyfile "$@"
		;;

	i | info)
		echo "# Test with https://caddy.test.h"
		echo "caddy home: $caddy_dir"
		echo "conf file : $conf_file"
		# sudo ls -l $caddy_dir

		# curl -L http://localhost:2019/config | jq -r ".apps.pki.certificate_authorities.local.name"
		local label=$(caddy adapt --config $conf_file | jq -r ".apps.pki.certificate_authorities.local.name")
		echo "Local CA Name: $label" # Caddy Local Lab Prod CA - 2026 ECC Root
		echo "Daemon service label: $svc_label"
		;;
	conf)
		cat $conf_file
		;;
	certs)
		echo "root cert: $local_root_cert" # /var/lib/caddy/data/caddy/pki/authorities/local/root.crt
		sudo ls -l "$caddy_dir/certificates/local/"
		;;
	cert | cert.root)
		sudo ls -l $local_root_cert
		sudo certtool d $local_root_cert
		;;
	cert.verify)
		(
			set -x
			sudo security verify-cert -r $local_root_cert
		)
		;;
	cert.kc)
		sudo openssl x509 -noout -fingerprint -sha1 -in $local_root_cert | sed 's/^.*=//' | tr -d ':' | kc-util cert find-by-fp
		;;
	trust.info | trust.settings)
		security dump-trust-settings -d | grep "Caddy Local" -A 50
		;;
	trust)
		# 注意： trust 会从 admin api获取证书并加入本地keychain store，本身不产生证书
		# Caddy服务首次启动时自动生成local ca keys，并加入本地keychain，但没有设置信任（需要权限），需要这里明确设置，否则会不生效
		sudo caddy trust --config $conf_file
		# 可通过Keychain Access.app查看，或使用命令行 security dump-trust-settings -d
		# 设置了下面两项信任
		# Trust Setting 0:
		#   Policy OID            : SSL
		#   Result Type           : kSecTrustSettingsResultTrustRoot
		# Trust Setting 1:
		#   Policy OID            : Apple X509 Basic
		#   Result Type           : kSecTrustSettingsResultTrustRoot
		;;

	## 可通过 以下命令设置(但使用上面官方更可靠！！！)
	trust.set)
		sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $local_root_cert
		;;
	trust.unset)
		sudo security remove-trusted-cert -d $local_root_cert
		;;
	reup)
		sudo lctl reup $svc_label
		;;
	log)
		tail -f -n 200 /var/log/caddy.*
		# sudo lctl log $svc_label
		;;
	clear | reset)
		# pkill caddy
		# sudo lctl stop $svc_label
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
