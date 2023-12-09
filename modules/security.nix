_: {
  config,
  lib,
  ...
}: let
  cfg = config.hey.security;
  secOption = name:
    lib.mkOption {
      description = "Enable security option ${name}";
      default = true;
      readOnly = true;
      type = lib.types.bool;
    };
in {
  options.hey.security = {
    sudo = secOption "sudo";
    kernel = secOption "kernel";
  };

  config = {
    security.sudo = lib.mkIf cfg.sudo {
      execWheelOnly = true;
    };
    security.protectKernelImage = cfg.kernel;
  };
}
