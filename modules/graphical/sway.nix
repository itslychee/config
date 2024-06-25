{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
in {
  options.hey.wms.sway = {
    enable = mkEnableOption "Sway";
  };
  config = mkIf config.hey.wms.sway.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = lib.concatStringsSep " " [
          (getExe pkgs.greetd.tuigreet)
          "--cmd ${getExe pkgs.swayfx}"
          "--asterisks"
          "--time"
        ];
      };
    };

    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };
  };
}
