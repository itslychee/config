{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hey.matrix;
  mkStr = lib.mkOption { type = lib.types.str; };
in {
  options.hey.matrix = {
    enable = lib.mkEnableOption "matrix";
    serverName = mkStr;
    matrixHostname = mkStr;
  };
  config = lib.mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        ensureUsers = [{
          name = "dendrite";
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }];
        ensureDatabases = [ "dendrite" ];
      };

       dendrite = {
         enable = true;
         environmentFile = config.age.secrets.matrix-registration.path;
          settings = {
            global = {
              server_name = cfg.serverName;
              private_key = "/$CREDENTIALS_DIRECTORY/skey";
              database = {
                connection_string = "postgresql:///dendrite?host=/run/postgresql";
              };
            };
            client_api = {
              registration_disabled = true;
              registration_shared_secret = ''''${REGISTRATION_SHARED_SECRET}'';
            };
          };
          loadCredential = [
            "skey:${config.age.secrets.matrix-serverkey.path}"
          ];
       }; 
      
      caddy = {
        enable = true;
        virtualHosts = {
          ${cfg.serverName}.extraConfig = ''
            header /.well-known/matrix/* Content-Type application/json
            header /.well-known/matrix/* Access-Control-Allow-Origin *
            respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://${cfg.matrixHostname}"}}`
            respond /.well-known/matrix/server `{"m.server": "${cfg.matrixHostname}:443"}`
          '';

          ${cfg.matrixHostname}.extraConfig = ''
            reverse_proxy /_matrix/* http://[::1]:${toString config.services.dendrite.httpPort}
            reverse_proxy /_synapse/client/* http://[::1]:${toString config.services.dendrite.httpPort}
          '';
        };
      };
    };
    systemd.services.dendrite.after = lib.mkIf config.services.dendrite.enable [ "postgresql.service" ];
  };
}
