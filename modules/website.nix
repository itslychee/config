{
  lib,
  config,
  ...
}:
let
  cfg = config.hey.lefishe;
in {
  options = {
    hey.lefishe.enable = lib.mkEnableOption "lefishe.club website";
  };
  config = lib.mkIf cfg.enable {
    services.caddy.enable = true;
    services.caddy.virtualHosts = {
      "lefishe.club" = {
        extraConfig = ''
          root * ${../assets}/
          file_server {
            index LeFishe.jpg
          }
        '';
      };
    };
  };

}
