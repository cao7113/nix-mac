{ pkgs, ... }:
{
  programs.mise = {
    enable = true;
    # 启用全局设置，mise 会自动 hook 到你的 shell (zsh/bash/fish)
    enableZshIntegration = true;
    # enableBashIntegration = true;

    # 工业级配置：直接在 Nix 中声明全局默认版本
    globalConfig = {
      # mise install
      tools = {
        usage = "latest"; # 增强 mise 的自动补全功能
        # node = "20";
        # python = "3.11";
        # go = "latest";
        # elixir = "latest"
        # erlang = "latest"
        # fnox = "latest"
        # bitwarden = "latest"
      };

      # https://mise.jdx.dev/configuration/settings.html
      settings = {
        experimental = true; # 开启实验性功能（如更强的环境变量管理）
        status.show_env = true;
        # verbose = true; # 输出更详细的日志，方便调试和了解 mise 的内部工作原理
      };
    };
  };

  # 运行 mise settings 确认 shims 相关设置为 false，这能保证你在 VS Code 等 IDE 中调用编译器时，获得与终端完全一致的路径响应，且没有任何性能损耗

  programs.zsh.initContent = ''
    # 确保 Nix 的 bin 路径在最前面，防止被 mise 误覆盖系统关键工具
    # export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"

    # Trust them with `mise trust`. See https://mise.jdx.dev/cli/trust.html for more information.
    # mise ERROR Run with --verbose or MISE_VERBOSE=1 for more information

    function m(){
      local act=$1

      (( $# > 0 )) && shift

      case $act in 
        rg)
          mise registry "$@"
          ;;
        remote)
          mise ls-remote "$@"
          ;;
        trust|ok|allow)
          mise trust "$@"
          ;;
        *) 
          mise $act "$@" 
          ;;
      esac
    }
  '';
}
