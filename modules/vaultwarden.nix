{
  config,
  lib,
  ...
}: let
  cfg = config.hey.services.vault;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str;
in
{ 
  options.hey.services.vault = {
    enable = mkEnableOption "Vaultwarden"; 
    domain = mkOption { type = str; description = "(sub)domain for vault"; };
  };
  config = mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        ensureUsers = [{
          name = "vaultwarden";
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }];
        ensureDatabases = [ "vaultwarden" ];
      };
      vaultwarden = {
        enable = true;
        dbBackend = true;
        config = {
          DATABASE_URL="postgresql://vaultwarden/vaultwarden";
        };
      };
      caddy = let
        cfg2 = config.services.vaultwarden.config;
      in {
        enable = true;
        virtualHosts.${cfg.domain}.extraConfig = ''
          reverse_proxy http://${cfg2.ROCKET_ADDRESS}:${cfg2.ROCKET_PORT}
        ''; 
      };
    };
  };

}
