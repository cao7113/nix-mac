{
  config,
  pkgs,
  lib,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ## common tools
    htop
    tree
    jq
    yq-go # 另一个 yq 实现，性能更好，功能更丰富，但语法略有不同
    # yq # jq 的 yaml 版本, python 实现，性能一般，但语法和 jq 一致
    fzf
    fd # 现代查找工具：用 Rust 编写，速度远超 find，默认忽略 .git
    ripgrep # 极速搜索工具：用于 frg 函数中的文本内容检索

    git
    gh

    ## direnv
    # direnv
    # nix-direnv

    ## nix related
    # format
    # nixfmt # 现在的 nixfmt 默认就是 RFC Style
    # nil # Nix 语言服务器

    # nix helper
    nh
    nix-tree

    ## flakehub helper cli for flakehub.com https://github.com/DeterminateSystems/fh
    # fh-repo.packages.${system}.default # too many dependencies
    # fh
    # inputs.fh.packages.${system}.default # 添加这一行来引用 determinate 提供的 fh
  ];
}
