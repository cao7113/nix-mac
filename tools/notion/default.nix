{
  config,
  pkgs,
  lib,
  username,
  need_least,
  ...
}:
{
  homebrew = {
    casks = lib.optionals (need_least "all") [
      "notion"
    ];
  };
}
