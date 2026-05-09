{
  # https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-flake.html#flake-format

  description = "Demo flake";

  inputs.nixpkgs.url = "nixpkgs";

  outputs =
    { self, nixpkgs }:
    {

      # The value returned by the outputs function must be an attribute set.
      # The attributes can have arbitrary values;
      # however, various nix subcommands require specific attributes to have a specific value
      demos.flake.demo.desc = "test demo flake";
      demos.flake.demo.msg = builtins.toString 123;
    };
}
