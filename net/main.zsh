# echo "# loading tools/net settings..."

net_rc_script="${${(%):-%x}}"
net_rc_dir=${net_rc_script:A:h}

function net() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	j | cd)
		cd $net_rc_dir
		;;
	vi)
		vi $net_rc_script
		source $net_rc_script
		;;
	s | test)
		set -x
		speedtest "$@"
		set +x
		;;
	sl)
		# get list servers
		speedtest -L
		;;
	t1)
		speedtest -s 43752
		;;
	*)
		type -f net
		;;
	esac
}

source $net_rc_dir/proxy.zsh
source $net_rc_dir/dns/rc.zsh

## curl
# 注意homebrew版本的curl和mac自带的/usr/bin/curl存在差异，如在使用系统证书，sslkeylog支持等
# 基于 curl 的 外交官属性（通过 -w 或 --write-out 参数格式化输出时间指标），能够非常详细地拆解出 DNS 解析、TCP 握手、TLS 握手、首字节响应以及总下载时间，并自动计算出下载速度。

# mock wget by curl
function wgeturl() {
	curl -L -O "$@"
}

function ports() {
	case $OSTYPE in
	darwin*)
		#sudo lsof -nPi TCP | sort -k9
		#sudo lsof -nPi TCP | { read -r header; echo "$header"; sort -k9; }
		#sudo lsof -nPi TCP | tail -n +2 | sort -k9
		sudo lsof -nPi TCP | awk 'NR>1' | sort -k9
		;;
	*)
		# on ubuntu
		# sudo apt install net-tools
		sudo netstat -lnput
		;;
	esac

	# sudo lsof -nP -iTCP:端口号 -sTCP:LISTEN
	# -n 表示不显示主机名
	# -P 表示不显示端口俗称
	# 不加 sudo 只能查看以当前用户运行的程序

	# lsof -nP -iTCP:4000 | grep LISTEN | awk '{print $2;}'
	# 输出占用该端口的 PID
}

#get specified interface's ip address
# $1: specified interface, e.g. wlan0, lo, eth0
# return string, e.g. 127.0.0.1
function host_ip() {
	iface=${1:-en0} # eth0
	ifconfig $iface | grep -o 'inet [^ ]*' | awk '{print $2}'
}

function ip() {
	iface=${1:-en0}
	echo "#iface: $iface ip"
	ipconfig getifaddr $iface
}

# alias myip="publicip"
# <<Note
#  https://crazyof.me/blog/archives/2686.html
#  https://www.blackmoreops.com/2015/06/14/how-to-get-public-ip-from-linux-terminal/

#  ipinfo-cli from https://github.com/ipinfo/cli
#  brew install ipinfo-cli
#  alias myip="ipinfo myip"
# Note

# # "https://ip.cn"
# # "https://ip.sb"
# # "https://ifconfig.cc"

# # Define an array with the list of URLs
# urls=(
# 	"https://ifconfig.me"
# 	"https://ip.gs"
# 	"https://httpbin.org/ip"
# 	"https://cip.cc"
# )

# # Loop through the array and curl each URL
# for url in "${urls[@]}"; do
# 	echo "Fetching IP from: $url"
# 	curl -L --connect-timeout 2000 --max-time 3 "$url"
# 	echo -e "\n" # Add a new line for better readability
# done

# # echo "${urls[@]}" | xargs -n 1 -P 5 -I {} bash -c 'echo "Fetching IP from: {}"; curl -L --max-time 5 --connect-timeout 2000 "{}"; echo -e "\n"'
