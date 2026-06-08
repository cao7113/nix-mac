# Mac related rc helpers

## launchd & launchctl & Daemon & Agent
# Mac 开机时，内核启动的第一个用户态进程就是 launchd（PID 为 1）
# 现代 macOS 引入了更严苛的后台任务框架（Background Tasks Framework）

# top -o cpu

# launchctl list

# 用户代理进程 只有在特定用户登录后才会启动，在用户的图形界面上下文（Session）中运行，权限与当前登录的用户相同。
function mac-agent() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	ls)
		ls -l ~/Library/LaunchAgents /Library/LaunchAgents
		;;
	paths | dirs)
		echo "~/Library/LaunchAgents	# 只对当前用户生效"
		echo "/Library/LaunchAgents 	# 对所有用户生效"
		;;
	*)
		type -f mac-agent
		;;
	esac
}

# 系统守护进程。与用户登录状态无关。无论有没有用户登录，只要 Mac 开机，它们就在后台运行。通常以 root 最高权限运行。
function mac-daemon() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	ls)
		set -x
		ls -l /Library/LaunchDaemons # /System/Library/LaunchDaemons
		set +x
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
