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
    mise/default.nix
    # devenv/default.nix
    db/pg/default.nix
    cloud/flyio/default.nix
    browser/default.nix
    notion/default.nix
  ];
}
