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
    services.matrix-conduit = {
      enable = true;
      settings.global = {
        server_name = cfg.serverName;
	enable_lightning_bolt = false;
      };
    };
    services.caddy = {
      enable = true;
      virtualHosts = {
          ${cfg.serverName} = let
            # Psuedo filesystem directory for Caddy to use.
            matrixDir = pkgs.symlinkJoin {
              name = "caddy-matrix";
              paths = [
                (pkgs.writeTextDir "client" (builtins.toJSON {
                  "m.homeserver".base_url = "https://${cfg.matrixHostname}"; 
                }))
                (pkgs.writeTextDir "server" (builtins.toJSON {
                  "m.server" = "${cfg.matrixHostname}:443";
                }))
              ];
            };
          in {
            extraConfig = ''
              handle_path /.well-known/matrix/* {
                root * ${matrixDir}
                file_server browse
                header Content-Type application/json
              }
            '';
          };
          ${cfg.matrixHostname} = {
	    serverAliases = [
	    	"${cfg.matrixHostname}:8448"
	    ];
            extraConfig = ''
              reverse_proxy /_matrix* http://[::1]:${toString config.services.matrix-conduit.settings.global.port}
            '';
          };
          
      };
    };
    networking.firewall.allowedTCPPorts = [ 8448 ];

  };
}
