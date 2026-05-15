alias direnvcmd="command direnv"
alias allow="direnvcmd allow"

function direnv(){
  local act=$1 
  (( $# > 0 )) && shift

  local this_script="${(%):-%x}"

  case $act in
    h|help)
      direnvcmd --help
      ;;
    man)
      man direnvcmd
      ;;
    v|version)
      direnvcmd --version
      ;;
    a)
      direnvcmd allow "$@"
      ;;
    f|file)
      echo $this_script
      ;;
    *)
      direnvcmd $act "$@"
      ;;
  esac
}

# 列出并统计所有已授权的 direnv 项目, 默认路径排序，-t时间排序
function direnv-list() {
    local allow_dir="${XDG_DATA_HOME:-$HOME/.local/share}/direnv/allow"
    [[ ! -d "$allow_dir" ]] && { echo "No direnv allow directory found."; return 1 }

    local sort_by_time=false
    [[ "$1" == "-t" ]] && sort_by_time=true

    zmodload -F zsh/stat b:zstat

    # 颜色定义
    local dim="\e[2m" blue="\e[34m" green="\e[32m" reset="\e[0m"

    echo "--- ${green}Trusted direnv Projects${reset} (Sorted by ${${sort_by_time/true/Time}/false/Path}) ---"
    printf "${dim}%-10s | %-17s | %s${reset}\n" "Hash(8)" "Modified" "Path"
    printf "${dim}%s${reset}\n" "----------|-------------------|------------------------------------"

    local -a entries
    local f target mtime_u mtime_s fname h8
    
    for f in "$allow_dir"/*(.); do
        target=$(cat "$f" 2>/dev/null)
        [[ -z "$target" ]] && continue
        
        # 获取元数据
        mtime_u=$(zstat +mtime "$f")
        mtime_s=$(zstat -F "%Y-%m-%d %H:%M" +mtime "$f")
        
        # 修复：先取文件名，再截取前8位，避免修饰符冲突
        fname="${f:t}"
        h8="${fname[1,8]}"

        # 封装数据，使用特殊占位符 @@@
        if $sort_by_time; then
            entries+=("${mtime_u}@@@${h8}@@@${mtime_s}@@@${target}")
        else
            entries+=("${target}@@@${h8}@@@${mtime_s}@@@${mtime_u}")
        fi
    done

    # 使用 Zsh 内置排序标识符 (Parameter Expansion Flags)
    # (n): 数值排序, (o): 升序, (O): 降序
    if $sort_by_time; then
        entries=(${(On)entries}) # 时间戳数值降序
    else
        entries=(${(o)entries})  # 路径字符串升序
    fi

    local line p h t
    for line in "${entries[@]}"; do
        # 使用 Zsh 内置拆分，不依赖外部 read 或 IFS
        local parts=("${(@s:@@@:)line}")
        
        if $sort_by_time; then
            h="${parts[2]}" t="${parts[3]}" p="${parts[4]}"
        else
            p="${parts[1]}" h="${parts[2]}" t="${parts[3]}"
        fi
        
        printf "${blue}%-10s${reset} | ${dim}%-17s${reset} | ${green}%s${reset}\n" "$h" "$t" "$p"
    done
}

function direnv-clean() {
    local allow_dir="${XDG_DATA_HOME:-$HOME/.local/share}/direnv/allow"
    if [[ ! -d "$allow_dir" ]]; then
        echo "No direnv allow directory found."
        return 1
    fi

    echo "Cleaning direnv authorizations..."
    echo "1. Removing entries for non-existent paths..."
    echo "2. Keeping only the latest record for each project..."

    # 使用关联数组：key 为路径，value 为对应的哈希文件名
    typeset -A latest_records
    local stale_count=0
    local dupe_count=0

    # 按文件修改时间从旧到新排序 (om: 排序, .: 只看普通文件)
    # Zsh 扩展 glob: *(om) 表示按 mtime 排序
    for f in "$allow_dir"/*(om); do
        local target=$(cat "$f")
        
        # 检查路径是否还存在
        if [[ ! -e "$target" ]]; then
            rm "$f"
            ((stale_count++))
            continue
        fi

        # 如果这个路径已经存在于数组中，说明当前处理的是更旧的记录（因为是按时间排序）
        if [[ -n "${latest_records[$target]}" ]]; then
            rm "$f"
            ((dupe_count++))
        else
            # 这是该路径目前发现的最新的记录
            latest_records[$target]="$f"
        fi
    done

    echo "Done! Removed $stale_count stale paths and $dupe_count duplicate records."
}