{
  lib,
  config,
  ...
}:
let
  cfg = config.hey.services.website;
  inherit (lib) mkEnableOption mkOption mkIf types ;
in {
  options.hey.services.website = {
    enable = mkEnableOption "Server";
    domain = mkOption { type = types.str; };
  };
  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts.${cfg.domain}.extraConfig = ''
        root * ${../assets}/
        file_server {
          index LeFishe.jpg
        }
      '';
    };
  };

}
