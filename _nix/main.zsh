# nixhome="${${(%):-%x}:h}"
alias n=nix
alias nj="nix j"
alias np="nix-profile"

alias nixcmd="command nix"
alias nixrgcmd="nixcmd registry"
alias nixflakecmd="nixcmd flake"
alias nixprofilecmd="nixcmd profile"

nix_rc_script="${(%):-%x}"
nix_rc_dir=${nix_rc_script:A:h}

# support old stype commands
export NIX_PATH=$nix_rc_dir/_local

# 禁用对特定命令的路径扩展（推荐方案）
alias nix='noglob nix' # nix run nixpkgs#cowsay 
# nix run nixpkgs\#cowsay -- "Hello"
# nix run "nixpkgs#cowsay" -- "Hello"

function nix(){
  local act=$1
  (( $# > 0 )) && shift

  local this_script="$nix_rc_script"
  local this_dir=${this_script:A:h}

  # todo take --debug 

  case $act in
    j|cd)
      cd $this_dir
      ;;
    h|man|doc)
      open https://nix.dev/reference/nix-manual
      ;;
    help)
      nixcmd --help "$@"
      ;;
    i|info)
      echo "this_script=$this_script"
      echo "this_dir=$this_dir"
      ;;
    lab)
      cd $this_dir/lab/"$@"
      ;;
    d|dev)
      nixcmd develop "$@"
      ;;
    sh)
      # noglob to escape #
      # noglob nix shell nixpkgs#htop -c htop
      nixcmd shell "$@"
      ;;
    b)
      nixcmd build "$@"
      ;;
    r)
      nixcmd run "$@"
      ;;
    or|off-r|off-run)
      nixcmd --offline run "$@"
      ;;
    f|fl)
      nix-flake "$@"
      ;;
    rg)
      nix-registry "$@"
      ;;
    p)
      nix-profile "$@"
      ;;
    fm|fmt)
      # nix fmt -vv "$@"
      rg --files -g "*.nix" -0 | xargs -0 nixfmt
      ;;
    st|store)
      du -hs /nix/store
      ;;
    store-nix)
      ls -ld /nix/store/*-nix-*
      ;;
    gc|clean-store)
      nix-collect-garbage -d
      ;;
    v)
      nixcmd --version
      ;;
    *)
      nixcmd $act "$@"
      ;;
  esac
}

function nix-profile(){
  local act=$1
  (( $# > 0 )) && shift

  case $act in
    l|ls)
      nixprofilecmd list "$@"
      ;;
    rm|del)
      nixprofilecmd remove "$@"
      ;;
    install)
      nixprofilecmd add "$@"
      ;;
    up)
      nixprofilecmd upgrade "$@"
      ;;
    his|info)
      nixprofilecmd history
      ;;
    back)
       nixcmd profile rollback
      ;;
    to)
      # nixprofilecmd switch --to "$@"
       nixprofilecmd --to "$@"
      ;;
    *)
      nixprofilecmd $act "$@"
      ;;
  esac
}

function nix-flake(){
  local act=$1
  (( $# > 0 )) && shift

  case $act in
    m|meta)
      nixflakecmd metadata "$@"
      ;;
    i)
      nixflakecmd info "$@"
      ;;
    s)
      nixflakecmd show "$@"
      ;;
    c)
      nixflakecmd check "$@"
      ;;
    *)
      nixflakecmd $act "$@"
      ;;
  esac
}

function nix-registry(){
  local act=$1
  (( $# > 0 )) && shift

  case $act in
    l|ls)
      nixrgcmd list "$@"
      ;;
    rm|del)
      nixrgcmd remove "$@"
      ;;
    *)
      nixrgcmd $act "$@"
      ;;
  esac
}
