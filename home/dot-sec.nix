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

  # 如果 .sec 存在，则加载其中的 home-manager 模块: home.nix 入口文件
  secHomeFile = "${secPath}/home.nix";
  hasSec = builtins.pathExists secHomeFile; # 探测关键文件是否存在
in
{
  imports = (if hasSec then [ (import secHomeFile) ] else [ ]);

  home.activation = {
    checkSec = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "${secHomeFile}" ]; then
        # 使用 \033[0;33m 表示黄色
        printf "\033[0;33m提示: 目录不存在~/.sec，跳过私密配置! \033[0m\n"
      fi
    '';
  };
}
