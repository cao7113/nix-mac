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
      # Docker Desktop 替代品
      "orbstack"
    ];
  };
}
