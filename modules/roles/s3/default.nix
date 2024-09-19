{
  pkgs,
  lib,
  config,
  nodes,
  ...
}: let
  inherit (lib) mkIf types mkOption;
in {
  imports = lib.fileset.toList (lib.fileset.difference ./. ./default.nix);
  config = {
    deployment.tags = ["s3"];
    hey.roles.s3 = true;

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
        retry_join = builtins.attrNames (lib.filterAttrs (name: value: value.config.services.consul.enable) nodes);
        advertise_addr = ''{{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }}'';
        client_addr = ''{{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }} {{ GetAllInterfaces | include "flags" "loopback" | join "address" " " }}'';
        bind_addr = ''{{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }} {{ GetAllInterfaces | include "flags" "loopback" | join "address" " " }}'';
      };
    };

    services.resolved.extraConfig = ''
      [Resolve]
      DNS=127.0.0.1:8600
      DNSSEC=false
      Domains=~consul
    '';

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
      package = pkgs.garage_1_0_0;
      environmentFile = config.deployment.keys.garage-secrets.path;
      settings = {
        replication_factor = 2;
        compression_level = 0;
        rpc_public_addr = "REPLACE_ME_MEOW";
        rpc_bind_addr = "REPLACE_ME_MEOW";
        consul_discovery = {
          service_name = "garage-s3";
          consul_http_addr = "http://127.0.0.1:8500";
        };
        s3_api = {
          api_bind_addr = "[::]:3900";
          s3_region = "garage";
          root_domain = ".s3.wires.cafe";
        };
      };
    };

    systemd.services = {
      # Make changing this easier
      garage-fix = {
        before = ["garage.service"];
        after = ["tailscaled.service"];
        requires = ["garage.service" "tailscaled.service"];
        partOf = ["garage.service"];
        restartTriggers = [config.environment.etc."garage.toml".source];
        script = ''
          rm -f /run/garage.toml
          cp /etc/garage.toml /run/garage.toml
          export IP=$(${lib.getExe pkgs.tailscale} ip -6)
          sed -E -i "s/^rpc_bind_addr =.*/rpc_bind_addr = \"[$IP]:3901\"/" /run/garage.toml
          sed -E -i "s/^rpc_public_addr =.*/rpc_public_addr = \"[$IP]:3901\"/" /run/garage.toml
        '';
      };
      garage = {
        serviceConfig.ExecStart = lib.mkForce "${config.services.garage.package}/bin/garage -c/run/garage.toml server";
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
      allowedUDPPorts = [8301];
    };
  };
}
