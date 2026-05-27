readonly DOT_ZSHRC=~/.zshrc

function dsh(){
  local act=$1
  case $act in
    i|info)
      dsh_info
      ;;
    
    # dsh-profile todo refactor one util
    u|use|switch)
      shift
      dsh_use_profile "$@"
      dsh_reload
      ;;
    tmp-use)
      dsh_tmp_use_profile_id "$2"
      dsh_reload
      ;;
    p|profile)
      dsh_profile_info
      ;;
    pcd|pj)
      shift 
      if [[ -z "$1" ]]; then
        cd ${_DSH_PROFILE_RC:h}
      else
        cd $DSH_HOME/profiles/$1
      fi
      ;;

    o|omz)
      dsh pcd omz
      ;;
    r|up|reload)
      dsh_reload
      ;;
    clean)
      zsh_clean_compdump
      ;;
    core)
      local core_file="${${(%):-%x}:A}"
      echo "# core_file: $core_file"
      ;;
    l|ls|files)
      zsh_files
      ;;
    home)
      echo $DSH_HOME
      ;;
    ohome)
      echo $ZSH
      ;;
    v|version)
      zsh_info
      ;;
    kill|kill-self)
      local zshrc="$DOT_ZSHRC"
      if [[ -L "$zshrc" ]]; then
        # 如果是软链接，直接移除，为 Home Manager 腾出空间
        echo "Found symlink at $zshrc, removing..."
        rm "$zshrc"
      elif [[ -f "$zshrc" ]]; then
        # 如果是普通文件，按当前精确时间备份
        local backup="$zshrc.bak.$(date +%Y%m%d_%H%M%S)"
        echo "Found regular file at $zshrc, backing up to $backup"
        mv "$zshrc" "$backup"
      else
        echo "No $zshrc found, ready for Home Manager."
      fi
      ;;
    *)
      cd $DSH_HOME
      ;;
  esac
}

# typeset -fr dsh

function dsh_info() {
  cat <<-EOF
## Dsh info with zsh profile

# DSH_HOME          =   $DSH_HOME
# _DSHRC_FILE       =   $_DSHRC_FILE
# _DSH_PROFILE_RC   =   $_DSH_PROFILE_RC
# _DSH_PROFILE_DIR  =   $_DSH_PROFILE_DIR
EOF
}

function load_helpers() {
  local helpers_home=${1:-$DSH_HOME/helpers}
  source_dir_files $helpers_home "*.zsh"
}

function dsh_reload() {
  # like omz reload 
  exec zsh -l
}