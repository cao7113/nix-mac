alias mac=nix-mac
alias mup="mac up"
alias iup="mac iup"
alias machm=nix-mac-home-manager

mac_rc_script="${(%):-%x}"
mac_rc_dir=${mac_rc_script:A:h}

function nix-mac(){
  local act=$1
  (( $# > 0 )) && shift

  local this_script="${(%):-%x}"
  local this_dir=${this_script:A:h}

  case $act in
    j|cd)
      cd $this_dir
      ;;
    h|help|docs)
      darwin-help
      ;;
    gens|versions)
      sudo darwin-rebuild --list-generations | tail -r | head
      # # 删除除了最近几次以外的所有旧版本
      # sudo nix-env -p /nix/var/nix/profiles/System --delete-generations +3
      ;;
    st|status|now|current)
      ls -l /nix/var/nix/profiles/System
      ;;
    up|use)
      sudo darwin-rebuild switch --flake $this_dir --verbose
      ;;
    iup|impure)
      sudo darwin-rebuild switch --flake $this_dir --impure --verbose
      ;;
    back)
      sudo darwin-rebuild switch --flake $this_dir --rollback
      ;;
    build) 
      darwin-rebuild build --flake $this_dir
      ;;
    bins|sw)
      ls -l /run/current-system/sw/bin
      ;;
    tree|tui)
      nix-tree /run/current-system
      ;;
    refs)
      # 查看当前系统版本（Generation）是从哪些 Nix Store 路径构建出来的，可以使用以下命令。
      # 它会列出当前系统路径下引用的所有软件包
      nix-store -q --references /run/current-system | grep -v 'darwin-system'
      ;;
    v)
      darwin-version
      ;;
    repo)
      open https://github.com/nix-darwin/nix-darwin
      ;;
    *)
      cd $this_dir
      ;;
  esac
}

# The home-manager switch command performs a combined build and activation.
function nix-mac-home-manager(){
  local act=$1
  (( $# > 0 )) && shift

  local this_script="${(%):-%x}"
  local this_dir=${this_script:A:h}

  case $act in
    j|cd)
      cd $this_dir
      ;;
    h|help|docs)
      home-manager-help
      ;;
    man)
      man home-configuration.nix
      ;;
    bins)
      ls -l /etc/profiles/per-user/$(whoami)/bin/
      ;;
    repo)
      open https://github.com/nix-community/home-manager
      ;;
    v)
      nix-flake metadata --json | jq -r '.locks.nodes."home-manager".locked.rev'
      ;;
    session-vars)
      less ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      ;;
    *)
      cd $this_dir
      ;;
  esac
}