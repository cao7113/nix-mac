{
  config,
  pkgs,
  lib,
  ...
}:

{
  # golang
  # `mac/_local/home-manager/modules/programs/go.nix`
  # go env
  # [1/1/11 built, 2.5 KiB DL] building sops-install-secrets-0.0.1-go-modules (buildPhase): go: downloading golang.org/x/crypto v0.49.0
  # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/compilers/go

  programs.go = {
    # 是否启用 Go 模块配置。
    # 默认值: false
    enable = true;

    # 要安装的 Go 软件包。
    # 默认值: pkgs.go
    # 建议: 如果需要特定版本，可以改为 pkgs.go_1_22
    package = pkgs.go;

    # 自动安装/管理指定的 Go 包。
    # 默认值: {}
    # 注意: 这里键是包的导入路径，值是对应的 nixpkgs。
    # 实际上这在现代 Go 开发中用得较少，因为大家更习惯 go install 或 devShell。
    # packages = {
    #   "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
    #   "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
    #   # "golang.org/x/tools/cmd/goimports" = pkgs.gotools;
    # };

    # packages = mkOption {
    #   type = with types; attrsOf path;
    #   default = { };
    #   example = literalExpression ''
    #     {
    #       "golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
    #       "golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
    #     }
    #   '';
    #   description = "Packages to add to GOPATH.";
    # };

    env = {
      # 现在建议写成绝对路径。默认值通常是 "${config.home.homeDirectory}/go"
      GOPATH = "${config.home.homeDirectory}/go";

      # 默认值通常是 "${config.home.homeDirectory}/go/bin"
      GOBIN = "${config.home.homeDirectory}/go/bin";

      # 你也可以在这里直接设置其他的 Go 环境变量
      # GOPROXY = "https://goproxy.cn,direct";

      # 是否在私有模块中排除某些路径（对应 GOPRIVATE）。
      # 默认值: []
      # 示例: [ "*.corp.example.com" "github.com/my-org" ]
      # goPrivate = [ ];

      # 传递给 go 编译器的额外环境变量。
      # 默认值: {}
      # 示例: 开启 CGO 或者设置代理
      # extraConfig = {
      #   GOPROXY = "https://goproxy.cn,direct";
      #   GOSUMDB = "sum.golang.google.cn";
      #   CGO_ENABLED = "1";
      # };
    };

  };

  # 补充：通常为了完整的开发体验，你会配合 home.packages 安装周边工具
  home.packages = with pkgs; [
    gopls # 语言服务器 (LSP)
    delve # 调试器 (dlv)
    golangci-lint # 代码静态检查
    go-tools # 包含 staticcheck 等工具
  ];
}
