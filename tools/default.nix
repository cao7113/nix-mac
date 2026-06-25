{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  imports = [
    cli/direnv
    terminal/default.nix
    editors/default.nix
  ]
  ++ lib.optionals (need_least "brewer") [
    browser/default.nix
    notion/default.nix
  ]
  ++ lib.optionals (need_least "all") [
    mise/default.nix
    # devenv/default.nix
    db/pg/default.nix
    cloud/flyio/default.nix
  ];
}
