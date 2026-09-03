alias cdy="caddy-wrapper"

function caddy-wrapper() {
	local act="$1"
	(($# > 0)) && shift

	this_rc="${${(%):-%x}}"
	this_dir=${this_rc:A:h}

	local caddy_dir="$HOME/Library/Application Support/Caddy"
	local local_root_cert="$caddy_dir/pki/authorities/local/root.crt"
	local conf_file=/etc/caddy/Caddyfile

	case "$act" in
	i | info)
		echo "root cert: $local_root_cert"
		;;
	run)
		sudo caddy run --watch --config ./Caddyfile
		;;
	reup)
		sudo lctl reup org.nixos.caddy
		;;
	log)
		tail -f -n 200 /var/log/caddy.*
		;;
	fs)
		caddy file-server --listen :8080
		;;
	fmt)
		caddy fmt --overwrite "$@"
		;;
	conf)
		cat $conf_file
		;;
	setup)
		sudo caddy trust
		security find-certificate -c "Caddy Local Authority - 2026 ECC Root" -p /Library/Keychains/System.keychain >/tmp/caddy_root.crt
		sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy_root.crt
		rm -f /tmp/caddy_root.crt
		echo "Setup Caddy root certificate in System keychain as Always Trust"
		# security dump-trust-settings -d
		;;
	clear)
		pkill caddy
		rm -rf "$HOME/Library/Application Support/Caddy/certificates"
		rm -rf "$HOME/Library/Application Support/Caddy/pki"
		;;

	certs)
		sudo ls -l "$HOME/Library/Application Support/Caddy/certificates/local/"
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
