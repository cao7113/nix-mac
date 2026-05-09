let
  ## import lib only
  lib = import ~/.nix/_local/nixpkgs/lib;
  result = lib.evalModules {
    modules = [
      ./options.nix
      ./config.nix
    ];
  };

  ## import all pkgs and init
  # pkgs = import ~/.nix/_local/nixpkgs { };
  # result = pkgs.lib.evalModules {
  #   modules = [
  #     ./options.nix
  #     ./config.nix
  #   ];
  # };

  ## import lib only and direct use
  # evalModules = (import /Users/rj/.nix/_local/nixpkgs/lib).evalModules;
  # result = evalModules {
  #   modules = [
  #     ./options.nix
  #     ./config.nix
  #   ];
  # };
in
result.config
# result._type
