{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hey.services.matrix;
  inherit (lib) mkOption mkEnableOption types;
in {
  options.hey.services.matrix = {
    enable = mkEnableOption "matrix";
    serverName = mkOption {type = types.str;};
    matrixHostname = mkOption {type = types.str;};
    elementHostname = mkOption {type = types.str;};
  };
  config = lib.mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        initialScript = pkgs.writeText "synapse-init.sql" ''
          CREATE ROLE "matrix-synapse";
          CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
            TEMPLATE template0
            LC_COLLATE = "C"
            LC_CTYPE = "C";
        '';
      };

      matrix-synapse = {
        enable = true;
        settings = {
          registration_shared_secret_path = "/var/lib/matrix-synapse/secret-safe-with-me";
          server_name = cfg.serverName;
          url_preview_enabled = true;
          max_upload_size = "200M";
          registration_requires_token = true;
          presence.enabled = false;
          withJemalloc = true;
        };
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
            reverse_proxy /_matrix/* http://127.0.0.1:8008
            reverse_proxy /_synapse/* http://127.0.0.0.1:8008
          '';
        };
      };
    };
  };
}
