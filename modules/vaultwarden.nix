{
  config,
  lib,
}: let
  cfg = config.hey.services.vault;
in
{ 
  options.hey.services.vault = {
    enable = lib.mkEnableOption "Vaultwarden"; 
  };
  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = true;
    };
  };

}
