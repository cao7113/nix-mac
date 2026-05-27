## greeting demo module

{
  config,
  lib,
  ...
}:

with lib; # mkOption means lib.mkOption
let
  cfg = config.demos.greeting;
in
{
  # 1. module interface
  options.demos.greeting = {
    enable = mkEnableOption "Enable greeting nixer";
    name = mkOption {
      type = types.str;
      default = "nixer";
      description = "Your name";
    };
    msg = mkOption {
      type = types.str;
      default = "Hello, nixer!";
      description = "Greeting worlds";
    };
  };

  # 2. module impl.
  config = mkIf config.demos.greeting.enable {
    demos.greeting.msg = "Hello ${cfg.name}";
  };
}
