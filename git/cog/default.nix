{ pkgs, ... }:
{
  # 安装 cocogitto 二进制包
  home.packages = with pkgs; [
    cocogitto
  ];

  # 配置 Shell 自动补全 (以 Zsh 为例)
  programs.zsh = {
    initContent = ''
      # 开启 cog 命令行补全
      if command -v cog &> /dev/null; then
        source <(cog generate-completions zsh)
      fi
    '';
  };
}
