{
  description = "Hi nix with flake";
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";

    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0"; # Stable Nixpkgs (use 0.1 for unstable)
    # use registry
    nixpkgs.url = "nixpkgs";

    demoflake.url = ./flakes/demo;
    demoflake.inputs.nixpkgs.follows = "nixpkgs";

    # to include git submodule
    # self.submodules = true;
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-schemas,
      demoflake,
      ...
    }@_inputs:
    let
      supportedSystems = [
        # builtins.currentSystem
        "aarch64-darwin"
        # "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      # Schemas tell Nix about the structure of your flake's outputs
      schemas = flake-schemas.schemas;

      ## packages
      packages = forAllSystems (
        system:
        let
          # .legacyPackages:
          #   这是 Flakes 规范中的一个约定。 在 Nixpkgs 中，软件包的数量极其庞大（8万+），直接使用 packages 属性会导致评估性能极慢。
          #   因此，Nixpkgs 将其导出的所有包放在 legacyPackages 下，以兼容传统的非 Flake 调用方式，并允许延迟加载。
          pkgs = nixpkgs.legacyPackages.${system};

          result = nixpkgs.lib.evalModules {
            modules = [
              ./modules/greeting.nix
              {
                # # 因为没有 options/config 关键字，这里被自动包装进 config
                # config = {
                #   demos.greeting.enable = true;
                #   demos.greeting.name = "bob";
                # };
                demos.greeting.enable = true;
                demos.greeting.name = "bob";
              }
            ];
          };
        in
        {
          default = pkgs.writeShellScriptBin "hi-nix" ''
            echo "hello nix from native genAttrs on ${system} !"
            echo "${result.config.demos.greeting.msg}"

            echo "demo-flake: ${demoflake.demos.flake.demo.desc} msg: ${demoflake.demos.flake.demo.msg}"
            echo "demo-flake meta: outPath=${demoflake.outPath} ${demoflake.lastModifiedDate} ${demoflake.narHash}"
          '';

          # gnu hello command: nix run .\#ghello
          ghello = pkgs.hello;

          # manual build a pkg
          demopkg = pkgs.stdenv.mkDerivation {
            name = "demo-bin";

            # 强制不使用任何源代码输入，纯手动构建
            unpackPhase = "true";

            # 在这里编写你的硬核实验代码
            buildPhase = ''
              echo "building..."
              echo "#!/bin/sh" > demo-bin
              echo 'echo "system is ${system}"' >> demo-bin
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp demo-bin $out/bin
              chmod +x $out/bin/demo-bin
              echo "inistall demo-pkg"
            '';
          };
        }
      );

      ## dev-shells
      # mkShellNoCC better than mkShell if no need c compiler toolchain
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              hello
              cowsay
              lolcat
              # ???
              # self.packages.${system}.demopkg
              # figlet curl git jq
              # nixpkgs-fmt
            ];

            # nativeBuildInputs = with pkgs; [
            #   # openssl
            # ];

            ENV_A = "a static env var";

            shellHook = ''
              export ENV_HOOK_A="(nix-dev)"
              echo "ENV_A=$ENV_A"
              echo "ENV_HOOK_A=$ENV_HOOK_A"

              # aliases
              alias e=exit

              echo "Welcome to the devShell!"
              echo

              # cowsay -f tux "Hello" | lolcat
              # cowsay "Nix with flakes is awesome! " | lolcat
            '';
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # 测试脚本：运行 hello-nix 并检查输出是否包含 "hello"
          test-output = pkgs.runCommand "test-hello-output" { } ''
            # 运行我们刚刚定义的 packages.default
            ${self.packages.${system}.default}/bin/hi-nix > output.txt

            # 使用 grep 检查内容，如果没找到 hello，grep 会以非零状态退出，导致构建失败
            grep "hello" output.txt

            ## just for test
            echo "Inputs metadata："
            echo "${builtins.toJSON self.inputs}"

            # 如果成功，必须创建一个输出文件（Nix 的要求）
            touch $out
          '';
        }
      );
    };

  # nixConfig = {
  #   extra-substituters = [
  #     "https://nix-community.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org-1:...="
  #   ];
  # };
}
