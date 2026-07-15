# Mac helpers

# top -o cpu

# launchd services
alias reup="sudo launchctl reboot"
alias lc="lctl"
alias agent="lctl"
alias daemon="sudo lctl"

# unified logging
alias logcmd="command log"
disable log # 修复zsh内置log 与mac下log命令（/usr/bin/log）冲突！！！

function lg() {
	local act=$1
	(($# > 0)) && shift

	case "$act" in
	h)
		logcmd help "$@"
		# log help predicates
		;;
	t | test)
		# swift -e 'import OSLog; Logger(subsystem: "my.test.app", category: "Backend").info("守护进程心跳正常")'
		logcmd emit --subsystem "test.app" --category "UI" --type debug --public "test log only" --public "$@"
		;;
	w | watch)
		logcmd stream --predicate 'subsystem == "test.app"' --level debug "$@"
		;;
	jw | json-watch | jlog-trace)
		logcmd stream --predicate 'subsystem == "test.app"' --level debug --style json "$@"
		;;
	s)
		logcmd stream "$@"
		# logger 命令发出，最稳妥的是过滤 process == "logger" 或匹配日志内容
		# log stream --info --predicate 'subsystem == "com.apple.syslog" AND eventMessage CONTAINS "Test"'
		# log stream --predicate 'process == "logger"' --level info
		;;
	slog)
		logcmd stream --style json --predicate 'process == "logger"' --level info "$@"
		;;
	# config)
	# 	sudo log config --mode "level:debug" --subsystem com.yourcompany.yourdaemon
	# 	;;
	reset)
		sudo log config --reset
		;;
	x)
		logcmd "$@"
		;;
	what)
		type -f ${funcstack[1]}
		;;
	*)
		logcmd "$act" "$@"
		;;
	esac
}

# {
#   "timezoneName" : "",
#   "messageType" : "Info",
#   "eventType" : "logEvent",
#   "source" : null,
#   "formatString" : "%s",
#   "userID" : 501,
#   "activityIdentifier" : 0,
#   "subsystem" : "",
#   "category" : "",
#   "threadID" : 4196680,
#   "senderImageUUID" : "607679EB-50E5-30F8-B6E1-9D2B7F35A580",
#   "backtrace" : {
#     "frames" : [
#       {
#         "imageOffset" : 1764,
#         "imageUUID" : "607679EB-50E5-30F8-B6E1-9D2B7F35A580"
#       }
#     ]
#   },
#   "bootUUID" : "",
#   "processImagePath" : "\/usr\/bin\/logger",
#   "senderImagePath" : "\/usr\/bin\/logger",
#   "timestamp" : "2026-07-13 13:05:55.747277+0800",
#   "machTimestamp" : 24312463404551,
#   "eventMessage" : "[PID=22320] Heartbeat status check: MODE=production",
#   "processImageUUID" : "607679EB-50E5-30F8-B6E1-9D2B7F35A580",
#   "traceID" : 13353070231812,
#   "processID" : 24159,
#   "senderProgramCounter" : 1764,
#   "parentActivityIdentifier" : 0
# }
