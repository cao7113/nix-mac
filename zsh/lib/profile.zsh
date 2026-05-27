# --- 配置与常量 ---
readonly DSH_DOT_PROFILE_FILE="${HOME}/.zsh_dsh_profile"
readonly DSH_PROFILE_ID_DEFAULT="omz"

# 使用 typeset -gr 定义只读全局关联数组
typeset -grA DSH_PROFILE_ALIASES=(
  a "ant"
  o "omz"
  b "bare"
  p "play"
  d "dummy"
)

# --- 核心函数 ---
# todo refactor to dsh_profile

function dsh_use_profile() {
  local target_id="$1"
  
  if [[ -z "$target_id" ]]; then
    echo "Usage: dsh_use_profile <ID|Alias>"
    echo "Available mappings:"
    for k v in "${(@kv)DSH_PROFILE_ALIASES}"; do
      printf "  \e[34m%-3s\e[0m -> %s\n" "$k" "$v"
    done
    return 1
  fi

  # 别名转换：优先检查是否是别名，否则直接使用输入值
  local profile_id="${DSH_PROFILE_ALIASES[$target_id]:-$target_id}"

  # 验证路径是否存在 (可选，增强健壮性)
  local target_rc="${DSH_HOME}/profiles/${profile_id}/main.zsh"
  if [[ ! -f "$target_rc" ]]; then
    echo "❌ Error: Profile '$profile_id' not found at $target_rc"
    return 1
  fi

  # 写入文件并更新当前 Session 变量
  export DSH_PROFILE_ID="$profile_id"
  echo -n "$profile_id" > "$DSH_DOT_PROFILE_FILE"
  
  print -P "✅ Switched to: %F{green}$profile_id%f (Restart shell or run 'dsh_checkout_profile')"
}

# only set the environment part not the file part!
function dsh_tmp_use_profile_id(){
  if [[ -z "$1" ]]; then
    print -P "%F{red}[dsh] Error:%f valid profile-id required!"
    return 1
  fi
  export DSH_PROFILE_ID="$1"
}

function dsh_get_profile_id() {
  # 1. 优先使用环境变量 (内存缓存)
  if [[ -n "$DSH_PROFILE_ID" ]]; then
    echo "$DSH_PROFILE_ID"
    return
  fi

  # 2. 其次读取持久化文件
  if [[ -f "$DSH_DOT_PROFILE_FILE" ]]; then
    export DSH_PROFILE_ID=$(<"$DSH_DOT_PROFILE_FILE") # 使用 $(<file) 替代 cat，速度更快
  else
    export DSH_PROFILE_ID="$DSH_PROFILE_ID_DEFAULT"
  fi
  
  echo "$DSH_PROFILE_ID"
}


function dsh_profile_info() {
  local profile_id="$DSH_PROFILE_ID"
  local profile_file_content="-"
  if [ -f $DSH_DOT_PROFILE_FILE ]; then
    profile_file_content=$(<"$DSH_DOT_PROFILE_FILE")
  fi
  cat <<EOF
## DSH Profile Information
Profile ID: $profile_id
Profile File: $DSH_DOT_PROFILE_FILE
Profile File Content: $profile_file_content
_DSH_PROFILE_RC: $_DSH_PROFILE_RC
EOF
}

function dsh_checkout_profile() {
  local profile_id=$(dsh_get_profile_id)
  local profile_rc="${DSH_HOME}/profiles/${profile_id}/main.zsh"

  if [[ -f "$profile_rc" ]]; then
    # :A 展开为绝对路径，:h 获取目录
    _DSH_PROFILE_RC="${profile_rc:A}"
    _DSH_PROFILE_DIR="${_DSH_PROFILE_RC:h}"
    source "$_DSH_PROFILE_RC"
  else
    print -P "%F{yellow}[dsh] Warning:%f Profile not found: $profile_rc"
    echo "Run: dsh_use_profile [id]"
  fi
}