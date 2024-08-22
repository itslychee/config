{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkIf;
in {
  options.services.tailscale = {
    ip = lib.mkOption {
      type = lib.types.str;
      description = "Set when you need the Tailscale IP of a host";
    };
  };
  config = mkMerge [
    (mkIf config.services.garage.enable {
      deployment.keys.garage-secrets = {
        destDir = "/var/lib/secrets/garage";
        keyCommand = [
          "gpg"
          "--decrypt"
          (toString ../secrets/garage-secrets.gpg)
        ];
      };
    })
    {
      networking.firewall.trustedInterfaces = [config.services.tailscale.interfaceName];

      services.garage = {
        package = pkgs.garage_1_0_0;
        environmentFile = "/var/lib/secrets/garage/garage-secrets";
        settings = {
          rpc_bind_addr = "${config.services.tailscale.ip}:8000";
          rpc_public_addr = "${config.services.tailscale.ip}:8000";
          root_domain = "s3.wires.cafe";
          replication_factor = 3;
          consul_discovery = {
            consul_http_addr = "http://127.0.0.1:8500";
            service_name = "garage-s3";
            tags = ["garage"];
          };

          s3_api = {
            api_bind_addr = "${config.services.tailscale.ip}:8001";
            s3_region = "lychee";
          };
          admin = {
            api_bind_addr = "${config.services.tailscale.ip}:8002";
          };
        };
      };
    }
  ];
}
