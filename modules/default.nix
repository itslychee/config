{self, ...} @ inputs: {
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    ;
  inherit
    (lib.types)
    str
    ;
  cfg = config.hey.time;
in {
  imports = [
    (self.lib.mkImport ./security.nix)
    (self.lib.mkImport ./hardware.nix)
    (self.lib.mkImport ./graphical.nix)
    (self.lib.mkImport ./boot.nix)
    (self.lib.mkImport ./users)
  ];

  # I want to be able to declare the majority of my config under
  # the hey attrset for aesthetics, plus the time suboptions are an
  # eyefull.
  options.hey.time = {
    localtime = mkEnableOption "Use localtime";
    zone = mkOption {
      default = "US/Central";
      type = str;
      description = "Set timezone";
    };
  };

  config = {
    time.timeZone = cfg.zone;
    time.hardwareClockInLocalTime = cfg.localtime;
  };
}
