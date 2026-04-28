# macos tools

alias lctl=launchctl

function launch-path() {
  local tp=${1:-user-agent}
  case $tp in
    agent|user-agent)
      echo ~/Library/LaunchAgents
      ;;
    app-agent)
      echo /Library/LaunchAgents
      ;;
    system-agent)
      echo /System/Library/LaunchAgents
      ;;
    app-daemon)
      echo /Library/LaunchDaemons
      ;;
    system-daemon)
      echo /System/Library/LaunchDaemons
      ;;
    *)
      echo "unknown type: $tp"
      ;;
  esac
}

## launchd
# ~/Library/LaunchAgents/
# /Library/Lauch{Daemons,Agents}
# /System/Library/Lauch{Daemons,Agents}
# man launchd.plist
# function reload_plist(){
#   [ $# -lt 1 ] && echo require plist path && return 1
#   plist=$1
#   sudo launchctl unload $plist
#   sudo launchctl load $plist
#   echo ==has reload $plist
# }
# alias uagents="cd ~/Library/LaunchAgents"

# launch service lunchy start redis
#LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
#if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
# . $LUNCHY_DIR/lunchy-completion.bash
#fi

## tools
# scutil # mange system configuration parameters

#$ sw_vers
#ProductName:  Mac OS X
#ProductVersion: 10.13.1
#BuildVersion: 17B1003

# return 

# MacOS versions history: 
# https://en.wikipedia.org/wiki/MacOS_version_history
# Darwin OS
# https://en.wikipedia.org/wiki/Darwin_(operating_system)
