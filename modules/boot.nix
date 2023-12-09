_: {
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkMerge
    mkOption
    mkEnableOption
    ;
  inherit
    (lib.types)
    bool
    nullOr
    int
    ;
  defaultOption = opt:
    mkOption {
      type = bool;
      default = true;
      description = "Whether to enable ${opt}";
    };
  cfg = config.hey.boot;
in {
  options.hey.boot = {
    systemd-boot = defaultOption "Systemd Boot";
    timeout = mkOption {
      type = nullOr int;
      default = 20;
    };
    tmp = defaultOption "Tmpfs on /tmp";
  };
  config = mkMerge [
    # Boot timeout
    (mkIf (cfg.timeout != null) {
      boot.loader.timeout = cfg.timeout;
    })
    # Systemd Boot
    (mkIf cfg.systemd-boot {
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot = {
        enable = true;
        consoleMode = "auto";
        editor = false;
      };
    })
    # Enable tmpfs on /tmp
    (mkIf cfg.tmp {
      boot.tmp.useTmpfs = true;
      boot.tmp.cleanOnBoot = true;
    })
  ];
}
