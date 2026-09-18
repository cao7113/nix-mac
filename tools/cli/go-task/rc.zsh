# go-task helpers
alias t="task-wrapper"
alias tk="task-wrapper"
alias taskcmd="command task"
alias tkl="task-wrapper --list-all"
alias tkc="cat Taskfile.yml"

# https://taskfile.dev/docs/reference/templating#file-paths
# Taskfile 提供了几个预置变量，可以直接用来获取当前 Taskfile 所在的目录：
# {{.TASKFILE_DIR}}（最常用）：返回包含当前正在执行的 Taskfile 的绝对路径。
# {{.USER_WORKING_DIR}}：返回用户执行 task 命令时所在的位置（终端当前目录）。
# {{.TASKFILE}}：返回当前 Taskfile 的完整路径（包含文件名，如 /path/to/Taskfile.yml）。

function task-wrapper() {
	local act=$1
	(($# > 0)) && shift

	local this_rc="${(%):-%x}"
	local this_dir=${this_rc:A:h}

	case $act in
	home)
		echo $this_dir
		;;
	j)
		cd $this_dir
		;;
	vi)
		vi $this_rc
		source $this_rc
		;;
	rc)
		cat $this_rc
		;;
	*)
		taskcmd $act "$@"
		;;
	esac
}
