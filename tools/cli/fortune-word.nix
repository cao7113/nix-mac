{ pkgs, username, ... }:

# https://github.com/ruanyf/fortunes

# Unix 程序员最爱的“三剑客” fortune | cowsay | lolcat
# pkgs.fortune # old C-lang
# pkgs.fortune-kind # modern Rust-lang version, 依赖更少，功能更强大，支持更多平台

let
  # 1. 声明远程中文数据库资源
  # 从 ruanyf/fortunes 获取数据，保证多机同步与可复现性
  fortunes-chinese-src = pkgs.fetchFromGitHub {
    owner = "ruanyf";
    repo = "fortunes";
    rev = "master";
    # 如果构建时报错 Hash 校验失败，请根据提示替换为正确的 sha256
    # nix-prefetch-url --unpack https://github.com/ruanyf/fortunes/archive/master.tar.gz
    # path is '/nix/store/d94m6g1cclbq3jgb4059l25pcbvjvp2h-master.tar.gz'
    # 01x3fjbjsp52c3zwf7p94x2zwj4sxmcrj3vk4rmp8hq7f2z7qviv
    sha256 = "sha256-Rdyu8B+9vRzHnLz+B/9S7yOExlYjC1B5e/8vA7zJ8kM=";
  };

  # 2. 构建自定义命令包: fortune-word
  # 使用 writeShellApplication 会自动处理依赖路径，无需担心环境变量问题
  fortune-word = pkgs.writeShellApplication {
    name = "fortune-word";

    # 运行时依赖：脚本执行时会自动将这些工具加入临时 PATH
    runtimeInputs = [
      pkgs.fortune-kind
    ];

    text = ''
      # 数据库所在路径 (指向 Nix Store 中的镜像)
      DATA_PATH="${fortunes-chinese-src}/data"

      # 打印装饰线与随机内容
      echo "──────────────────────────────────────────"
      fortune-kind "$DATA_PATH"
      echo "──────────────────────────────────────────"
    '';
  };
in
{
  # 3. 安装自定义命令到用户环境
  home.packages = [
    fortune-word
  ];

  # 4. 设置别名 (Aliases)
  # 这样你输入 `word` 就会执行 `fortune-word`
  home.shellAliases = {
    word = "fortune-word";
  };
}
