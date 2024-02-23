{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.hey.services.kmscon;
in {
  options.hey.services.kmscon = {
    enable = mylib.mkDefaultOption;
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
