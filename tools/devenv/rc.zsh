alias devenvcmd="command devenv"

function de() {
  local act=$1

  local this_script="${(%):-%x}"
  local this_dir=${this_script:A:h}

  (( $# > 0 )) && shift

  case $act in 
    sh)
      if [[ -n "$DEVENV_STATE" ]]; then
        echo "⚠️  检测到已处于 devenv shell 中，禁止嵌套。"
        return 0
      fi
      devenvcmd shell "$@"

      ;;
    p|proc)
      local subcmd=$1
      (( $# > 0 )) && shift
      case $subcmd in
        ls)
          devenvcmd processes list "$@"
          ;;
        st)
          devenvcmd processes status "$@"
          ;;
        log)
          devenvcmd processes logs "$@"
          ;;
        h)
          devenvcmd processes help "$@"
          ;;
        *)
          devenvcmd processes $subcmd "$@"
          ;;
      esac

      ;;
    lab)
      cd $this_dir/lab
      ;;
    demo)
      cd $this_dir/lab/demo
      ;;
    v)
      devenvcmd version "$@"
      ;;
    h)
      devenvcmd help "$@"
      ;;
    i)
      devenvcmd info "$@"
      ;;
    *)
      devenvcmd "$act" "$@"
      ;;
  esac
}