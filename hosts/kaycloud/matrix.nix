{
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (builtins) toJSON;
  serverConfig = {
    "m.server" = "matrix.wires.cafe:443";
  };
  clientConfig = {
    "m.homeserver" = {
      base_url = "https://matrix.wires.cafe";
      server_name = "wires.cafe";
    };
  };
  # Implement MSC1929
  supportConfig = {
    contacts = [
      {
        matrix_id = "@lychee:wires.cafe";
        email_address = "itslychee@protonmail.com";
        role = "m.role.admin";
      }
    ];
  };
in
{
  services.matrix-conduit = {
    enable = true;
    package = inputs.conduwuit.packages.${pkgs.system}.default;
    settings.global = {
      server_name = "wires.cafe";
      max_request_size = 50000000; # 50 MBs
      allow_public_room_directory_over_federation = true;
      ip_lookup_strategy = 4; # We like IPv6
      database_backend = "rocksdb";
      allow_guests_auto_join_rooms = true;
      auto_join_rooms = [
        "!KOUIT9ZooerEDE9Lj4:wires.cafe"
      ];
    };
  };

  services.caddy.enable = true;
  services.caddy.virtualHosts =
    let
      element = pkgs.element-web.override {
        conf = {
          default_server_config = clientConfig;
          room_directory = [
            "matrix.org"
            "nixos.org"
          ];
          show_lab_settings = true;
          default_theme = "dark";
          default_country_code = "US";
          brand = "wires café";
        };
      };
    in
    {
      "wires.cafe".extraConfig = ''
        header /.well-known/matrix/* Content-Type application/json
        header /.well-known/matrix/* Access-Control-Allow-Origin *
        respond /.well-known/matrix/client  `${toJSON clientConfig}`
        respond /.well-known/matrix/server  `${toJSON serverConfig}`
        respond /.well-known/matrix/support `${toJSON supportConfig}`
      '';
      "matrix.wires.cafe".extraConfig =
        let
          conduit = config.services.matrix-conduit.settings.global;
        in
        ''
          reverse_proxy /_matrix* http://${conduit.address}:${toString conduit.port}
        '';
      # "cinny.wires.cafe".extraConfig = ''
      #   encode zstd gzip
      #   file_server * {
      #     # root ${cinny}
      #   }
      # '';
      "element.wires.cafe".extraConfig = ''
        encode zstd gzip
        file_server * {
          root ${element}
        }

      '';
    };
}
