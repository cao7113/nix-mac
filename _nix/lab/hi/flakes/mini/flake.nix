{
  description = "A truly minimalist flake without any inputs";

  # inputs 为空，完全不引用 nixpkgs
  inputs = { };

  outputs =
    { self }:
    {
      # 针对 macOS M1
      packages.aarch64-darwin.default = derivation {
        name = "pure-hello";
        system = "aarch64-darwin";

        # 必须指定构建器。
        # 注意：这依赖于你机器上 /bin/sh 必须存在，
        # 这在 Nix 哲学中属于“不纯”，但这是不依赖 nixpkgs 的唯一方法。
        builder = "/bin/sh";

        # 传入构建器的参数
        args = [
          "-c"
          ''
            mkdir -p $out/bin
            printf "#!/bin/sh\necho 'Hello from a flake with ZERO dependencies!'" > $out/bin/hello
            chmod +x $out/bin/hello
          ''
        ];
      };
    };
}
