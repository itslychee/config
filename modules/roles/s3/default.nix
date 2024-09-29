{
  pkgs,
  lib,
  config,
  nodes,
  ...
}:
let
  inherit (lib) mkIf types mkOption;
in
{
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);
  config = {
    deployment.tags = [ "s3" ];
    hey.roles.s3 = true;
    services.resolved.extraConfig = ''
      [Resolve]
      DNS=127.0.0.1:8600
      DNSSEC=false
      Domains=~consul
    '';

    # Thank you!
    #
    # https://github.com/viperML/dotfiles/blob/f6b62b75556b111815524675958e383cd5ef534c/modules/nixos/consul.nix#L20C9-L20C147
    services.consul = {
      enable = true;
      interface = {
        bind = config.services.tailscale.interfaceName;
        advertise = config.services.tailscale.interfaceName;
      };
      extraConfig = {
        retry_join = builtins.attrNames (
          lib.filterAttrs (name: value: value.config.services.consul.enable) nodes
        );
        advertise_addr = ''{{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }}'';
        bind_addr = ''{{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }} {{ GetAllInterfaces | include "flags" "loopback" | join "address" " " }}'';
      };
    };

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
        consul_discovery = {
          service_name = "garage-s3";
          consul_http_addr = "http://127.0.0.1:8500";
        };
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
