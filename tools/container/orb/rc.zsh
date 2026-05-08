alias oc="orbctl"
alias orbcmd="command orb"
function orb(){
  local act=$1
  
  local this_script="${(%):-%x}"
  local this_dir=${this_script:h}

  case $act in
    cd)
      cd $this_dir
      ;;
    home)
      echo $this_dir
      ;;
    l|ls|m|machine)
      orb list
      ;;
    *)
      orbcmd "$@"
      ;;
  esac
}

# orb proxy
# orbp() {
#   port=${1:-1086}
#   scheme=${2:-socks5h}
#   proxy=$scheme://host.internal:$port
#   cat <<-Doc
#     export http_proxy=$proxy
#     export https_proxy=$proxy
#     export HTTPS_PROXY=$proxy
#     export all_proxy=$proxy
#     export no_proxy=localhost,host.internal,localaddress,.localdomain.com
# Doc
# }