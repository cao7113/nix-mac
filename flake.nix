{
  description = "nix-darwin on Determinate Nix";

  # Flake inputs
  inputs = {
    # https://github.com/NixOS/nixpkgs/tree/nixpkgs-25.11-darwin
    # Stable Nixpkgs (use 0.1 for unstable)
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstabl
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    # https://github.com/DeterminateSystems/determinate
    # Determinate 3.* module
    determinate = {
      # url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      url = "github:DeterminateSystems/determinate/v3.17.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-darwin/nix-darwin/tree/nix-darwin-25.11
    nix-darwin = {
      # Stable nix-darwin (use 0.1 for unstable)
      # url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/home-manager/tree/release-25.11
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/mic92/sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dot-sec-data = {
    #   # 引用方式,语法示例,适用场景
    #   # 远程 SSH,git+ssh://...,多机同步，从服务器拉取加密数据。
    #   # 本地路径,path:/absolute/path,快速调试，直接读取文件夹内所有内容。
    #   # 本地 Git,git+file:///path,严格管理，仅引用已提交或暂存的配置文件。
    #   # url = "path:./sec-data";
    #   # 特别注意：path:/absolute/path 配置方式，当修改文件后需要运行update命令来更新内容到 Nix store 中，否则 Nix 仍然会使用旧的内容。命令示例：
    #   #  nix flake update dot-sec-data
    #   url = "path:/Users/rj/.sec-data";
    #   flake = false; # 这是一个普通的目录，不是一个 flake
    # };

    # fh = {
    #   url = "https://flakehub.com/f/DeterminateSystems/fh/0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  # say is /usr/bin/say

  # Flake outputs
  outputs =
    { self, ... }@inputs:
    let
      # The values for `username` and `system` supplied here are used to construct the hostname
      # for your system, of the form `${username}-${system}`. Set these values to what you'd like
      # the output of `scutil --get LocalHostName` to be.
      hostname = "mac";

      # Your system username
      username = "rj";

      # Your system type (Apple Silicon)
      system = "aarch64-darwin";

      # pkgs = inputs.nixpkgs.legacyPackages.${system};

      # test auto completion todo
      # # 显式告诉环境变量 nixpkgs 在哪里（针对 Flake 用户）
      # export NIX_PATH=nixpkgs=flake:nixpkgs
      # # 然后在终端中启动 VS Code，让它继承这个环境变量
      # code .
      # a = builtins.;

      # pkgs.runCommand "test-net" { buildInputs = [ pkgs.curl ]; } ''
      #   curl -I https://google.com > $out
      # '
    in
    {
      # nix-darwin configuration output
      darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
        inherit system;

        # 传递参数给子模块，这样子模块可以直接使用 username 和 inputs
        specialArgs = {
          inherit
            self
            inputs
            username
            hostname
            system
            ;
        };

        modules = [
          inputs.determinate.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          {
            # 必须通过 extraSpecialArgs 显式把 username 传给 home-manager 的内部模块
            # 隔离性：nix-darwin 和 home-manager 是两个独立的系统。你传给 darwinSystem 的参数，默认只在 nix-darwin 的配置项里有效。
            # 隧道效应：当你进入 home-manager.users.${username} 内部时，它开启了一个新的作用域。
            # 如果你不写 extraSpecialArgs，_home.nix 就拿不到外界的 username 变量。
            home-manager.extraSpecialArgs = { inherit username inputs; };
          }

          ## file modules
          ./darwin # /default.nix
          ./home
          ./tools
        ];
      };

      # nix eval .\#hi
      # hi = "Hello from the root of the flake! This is just a test output.";

      # Development environment
      devShells.${system}.default =
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          rebuild_tool = inputs.nix-darwin.packages.${system}.darwin-rebuild;

          macup =
            # Shell script for applying the nix-darwin configuration.
            # Run this to apply the configuration in this flake to your macOS system.
            (
              pkgs.writeShellApplication {
                name = "macup";
                runtimeInputs = [
                  # Make the darwin-rebuild package available in the script
                  rebuild_tool
                ];
                text = ''
                  echo "> Applying nix-darwin configuration..."

                  echo "> Running darwin-rebuild switch as root..."
                  sudo darwin-rebuild switch --flake ".#${hostname}"
                  echo "> darwin-rebuild switch was successful ✅"

                  echo "> macOS config was successfully applied 🚀"
                  echo "# 首次执行这个脚本后，需要重新进入nix develop或source /etc/static/bashrc"
                '';
              }
            );

          find_path =
            # https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
            (
              pkgs.writeShellApplication {
                name = "test-darwin-rebuild";
                runtimeInputs = [
                  # Make the darwin-rebuild package available in the script
                  rebuild_tool
                ];
                text = ''
                  echo "> Find darwin-rebuild path in shell app..."
                  which darwin-rebuild
                '';
              }
            );
        in
        pkgs.mkShellNoCC {

          # ENV_A = "a static env var";
          # buildInputs = with pkgs; [ hello ];

          packages = [
            rebuild_tool
            macup
            find_path
            self.formatter.${system}
          ];

          shellHook = ''
            echo "## Welcome to dot-mac in darwin env!"
          '';
        };

      # Nix formatter
      # nixfmt ??? todo
      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
