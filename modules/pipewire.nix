{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.hey.services.pipewire;
in {
  options.hey.services.pipewire = {
    enable = mkEnableOption "PipeWire";
  };
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    security.rtkit.enable = true;
  };
}
