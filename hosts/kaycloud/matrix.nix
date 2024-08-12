{
  inputs,
  pkgs,
  config,
  ...
}: let
  clientConfig = {
    "m.homeserver" = {
      base_url = "https://matrix.wires.cafe";
      server_name = "wires.cafe";
    };
  };
  serverConfig = {
    "m.server" = "matrix.wires.cafe:443";
  };
in {
  services.matrix-conduit = {
    enable = true;
    package = inputs.conduwuit.packages.${pkgs.system}.default;
    settings.global = {
      server_name = "wires.cafe";
      max_request_size = 50000000; # 50 MBs
    };
  };

  services.caddy.enable = true;
  services.caddy.virtualHosts = {
    "wires.cafe".extraConfig = ''
      header /.well-known/matrix/* Content-Type application/json
      header /.well-known/matrix/* Access-Control-Allow-Origin *
      respond /.well-known/matrix/client `${builtins.toJSON clientConfig}`
      respond /.well-known/matrix/server `${builtins.toJSON serverConfig}`
    '';
    "matrix.wires.cafe".extraConfig = let
      conduit = config.services.matrix-conduit.settings.global;
    in ''
      reverse_proxy /_matrix* http://${conduit.address}:${toString conduit.port}
    '';
    "cinny.wires.cafe".extraConfig = ''
      encode zstd gzip
      file_server * {
        root ${pkgs.cinny}
      }
    '';
  };
}
