alias misecmd="command mise"

function m(){
  local act=$1

  (( $# > 0 )) && shift

  case $act in 
    rg)
      misecmd registry "$@"
      ;;
    remote)
      misecmd ls-remote "$@"
      ;;
    trust|ok|allow)
      misecmd trust "$@"
      ;;
    *) 
      misecmd $act "$@" 
      ;;
  esac
}