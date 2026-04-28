# command fly is soft link to flyctl, ll /opt/homebrew/Cellar/flyctl/*/bin
alias flycmd="command fly"

function fly(){
  local act=${1:-help}
  (( $# > 0 )) && shift

  local this_script="${(%):-%x}"
  local this_dir=${this_script:h}

  case "$act" in 
     st)
       flycmd status
       ;;
     sh|con|console)
       flycmd ssh console
       ;;
     h|help)
       flycmd --help
       ;;
     j|cd)
       cd $this_dir
       ;;
     o|open)
       flycmd apps open $@ 
       ;;
     log)
       flycmd logs $@ 
       ;;
     sec)
       flycmd secrets $@ 
       ;;
     restart)
       # not works?
       flycmd m restart $@ 
       ;;
     dep)
       flycmd deploy --verbose $@ 
       ;;
     *)
       flycmd $act $@
       ;;
  esac
}