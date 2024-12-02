{
  pkgs,
  lib,
  config,
  nodes,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);
  config = {
    deployment.tags = [ "s3" ];
    hey.roles.s3 = true;

    deployment.keys.garage-secrets = mkIf config.services.garage.enable {
      destDir = "/var/lib/secrets/garage";
      keyCommand = [
        "gpg"
        "--decrypt"
        (toString ../../../secrets/garage-secrets.gpg)
      ];
    };

    services.garage = {
      enable = true;
      package = pkgs.garage_1_x;
      environmentFile = config.deployment.keys.garage-secrets.path;
      settings = {
        replication_factor = 2;
        compression_level = 0;
        rpc_public_addr_subnet = "fd7a:115c:a1e0::/48";
        rpc_bind_addr = "[::]:3901";
        s3_api = {
          api_bind_addr = "[::]:3900";
          s3_region = "garage";
          root_domain = ".s3.wires.cafe";
        };
        admin.api_bind_addr = "[::]:3902";
      };
    };

    assertions = lib.singleton {
      assertion = config.services.tailscale.enable;
      message = "tailscale required";
    };

    networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [
        # Garage
        3900
        3901
        # Consul https://developer.hashicorp.com/consul/docs/install/ports
        8300
        8301
        8500
        8600
      ];
      allowedUDPPorts = [ 8301 ];
    };
  };
}
