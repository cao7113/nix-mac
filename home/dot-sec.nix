{
  pkgs,
  config,
  lib,
  inputs,
  username,
  ...
}:
let
  # 注意：在 Flake 中使用绝对路径必须配合 --impure 参数
  secPath = "/Users/${username}/.sec";
  secZshFile = secPath + "/main.zsh";
  # 如果 .sec 存在，则加载其中的 home-manager 模块: home.nix 入口文件
  secHomeFile = secPath + "/home.nix";
  # 探测关键文件是否存在（需要 nix build --impure）
  hasSec = builtins.pathExists secHomeFile;
in
{
  # 1. 修复的导入语法：直接传入路径，由 Nix 自动加载
  imports = if hasSec then [ secHomeFile ] else [ ];

  # 2. 替代激活脚本：将检测和 source 逻辑直接写入 Zsh 的启动配置文件中
  programs.zsh.initContent = lib.mkAfter ''
    ## dot-sec helpers
    export dot_sec_home="${secPath}"

    if [ -f "${secZshFile}" ]; then
      source "${secZshFile}"
    else
      # 仅在交互式终端中提示，避免污染非交互脚本
      if [[ $- == *i* ]]; then
        printf "\033[0;33m提示: 未检测到私密配置 (${secZshFile})\033[0m\n"
      fi
    fi
  '';

  # 3. 如果你依然坚持要一个部署时的提示（仅做提示，不 source）
  home.activation = {
    checkSec = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
       if [ ! -f "${secHomeFile}" ]; then
        printf "\033[0;33m[Warning] 目录不存在 ${secHomeFile}，将跳过私密模块导入。\033[0m\n"
      fi
    '';
  };
}
