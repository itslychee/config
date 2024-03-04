{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.hey.services.kmscon;
in {
  options.hey.services.kmscon = {
    enable = mkEnableOption "Kmscon";
  };

  config.services.kmscon = mkIf cfg.enable {
    enable = true;
    fonts = [
      {
        name = "Terminus";
        package = pkgs.terminus_font;
      }
    ];
    hwRender = true;
    extraOptions = "--term xterm-256color";
  };
}
