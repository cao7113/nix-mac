# Mac related rc helpers

## launchd & launchctl & Daemon & Agent
# Mac 开机时，内核启动的第一个用户态进程就是 launchd（PID 为 1）
# 现代 macOS 引入了更严苛的后台任务框架（Background Tasks Framework）

# top -o cpu

# launchctl
# 新版本 macOS 引入了更安全、基于“领域（Domain）”概念的子命令。
# 旧语法 load 只是简单地读取文件，而新语法强制你指定 Target Domain（目标领域）。
# gui/501：表示“用户 ID 为 501 的图形界面会话”。这保证了任务能准确获取该用户的桌面、环境变量和图形上下文。
# system：表示“系统全局领域”。

## other tools
# brew install --cask launchcontrol
# brew install booter

alias agent="mac-agent"
# 用户代理进程 只有在特定用户登录后才会启动，在用户的图形界面上下文（Session）中运行，权限与当前登录的用户相同。
function mac-agent() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	l | ls)
		launchctl list | grep -v "com.apple"
		;;
	files)
		(
			set -x
			ls -l ~/Library/LaunchAgents /Library/LaunchAgents
		)
		;;
	p | print)
		if (($# == 0)); then
			launchctl print gui/$(id -u)
		else
			launchctl print gui/$(id -u)/"$1"
			# launchctl print gui/$(id -u)/com.qiuyuzhou.shadowsocksX-NG.local
		fi
		# launchctl print gui/$(id -u)/com.apple.Finder | grep -E "pid =|status =|state ="
		# launchctl print gui/$(id -u) | awk '/label =/{l=$3} /last exit status =/{if($5 != 0) print l " 崩溃退出码: " $5}'
		;;
	st | status)
		# com.qiuyuzhou.shadowsocksX-NG.local
		(($# == 0)) && {
			echo "Require job label"
			return 1
		}
		launchctl print gui/$(id -u)/$1 | grep -E "state =|pid =|last exit status ="
		;;
	up | start | load)
		# old style: load
		launchctl bootstrap gui/$(id -u) "$@" # ~/Library/LaunchAgents/com.user.task.plist
		;;
	down | stop | unload)
		launchctl bootout gui/$(id -u) "$@" # ~/Library/LaunchAgents/com.user.task.plist
		;;
	reup)
		(($# == 0)) && {
			echo "Require job label"
			return 1
		}
		launchctl kickstart -k gui/$(id -u)/"$1"
		# launchctl kickstart -k gui/$(id -u)/com.example.myenvjob
		# 强制触发/立刻执行任务
		# 有时候你的 .plist 设置了每隔一小时运行，但你想现在立刻测试它是否能跑通
		# # 语法：launchctl kickstart -k <Domain>/<Job-Label>
		# # -k 参数表示如果任务正在跑，先杀掉它再重启（类似 restart）
		# launchctl kickstart -k gui/$(id -u)/com.example.myenvjob
		;;
	paths | dirs)
		echo "~/Library/LaunchAgents				# 只对当前用户生效"
		echo "/Library/LaunchAgents 				# 对所有用户生效"
		# 受系统完整性保护（SIP）锁定。任何情况下都不要（也无法）去修改
		echo "/System/Library/LaunchAgents	# 系统自身(SIP保护)"
		;;
	*)
		type -f mac-agent
		;;
	esac
}

alias daemon="mac-daemon"
# 系统守护进程。与用户登录状态无关。无论有没有用户登录，只要 Mac 开机，它们就在后台运行。通常以 root 最高权限运行。
function mac-daemon() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	ls)
		sudo launchctl list
		;;
	files)
		(
			set -x
			ls -l /Library/LaunchDaemons # /System/Library/LaunchDaemons
		)
		;;
	p | print)
		if (($# == 0)); then
			sudo launchctl print system
		else
			sudo launchctl print system/"$1"
			# launchctl print gui/$(id -u)/com.qiuyuzhou.shadowsocksX-NG.local
		fi
		;;
	st | status)
		# com.qiuyuzhou.shadowsocksX-NG.local
		(($# == 0)) && {
			echo "Require job label"
			return 1
		}
		sudo launchctl print system $1 | grep -E "state =|pid =|last exit status ="
		;;
	up | load)
		sudo launchctl bootstrap system/"$@" # /Library/LaunchDaemons/com.system.task.plist
		;;
	down | unload)
		sudo launchctl bootout system/"$@" # /Library/LaunchDaemons/com.system.task.plist
		;;
	reup)
		(($# == 0)) && {
			echo "Require job label"
			return 1
		}
		sudo launchctl kickstart -k system/"$1"
		;;
	paths | dirs)
		echo "/Library/LaunchDaemons 				# 第三方软件安装"
		echo "/System/Library/LaunchDaemons	# 系统自带"
		;;
	*)
		type -f mac-daemon
		;;
	esac
}

## plist: property list

# show plist as json for readability
function pljson() {
	(($# == 0)) && echo "Require plist file path!" && return 1
	local plfile="$1"
	[[ -f $plfile ]] || {
		echo "Invalid plist file: $plfile"
		return 2
	}
	plutil -convert json -o - $plfile | jq
}

# function plyaml() {
# 	(($# == 0)) && echo "Require plist file path!" && return 1
# 	local plfile="$1"
# 	[[ -f $plfile ]] || {
# 		echo "Invalid plist file: $plfile"
# 		return 2
# 	}
# 	plutil -convert json -o - $plfile | yq -p json -o yaml
# }

## env
# # 1. 设置一个临时全局变量
# launchctl setenv MY_TEMP_VAR "hello_world"
# # 2. 检查变量是否设置成功
# launchctl getenv MY_TEMP_VAR
# # 3. 卸载该环境变量
# launchctl unsetenv MY_TEMP_VAR
