{
  config,
  lib,
  nodes,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkMerge
    mkIf
    flatten
    mapAttrsToList
    filterAttrs
    ;
  inherit
    (lib.types)
    bool
    ;
  cfg = config.hey;
in {
  options.hey = {
    useBuilders = mkOption {
      type = bool;
      default = false;
      description = "Use builder infrastructure";
    };
    isBuilder = mkEnableOption "Advertise host as a builder";
  };

  config = mkMerge [
    # Hosts that use builders
    (mkIf cfg.useBuilders {
      nix = {
        distributedBuilds = true;
        buildMachines =
          mapAttrsToList (hostName: node: {
            inherit hostName;
            systems = flatten [
              node.config.nixpkgs.hostPlatform.system
              node.config.boot.binfmt.emulatedSystems
            ];
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            sshUser = "builder";
            maxJobs = 40;
            mandatoryFeatures = [
              "big-parallel"
              "nixos-test"
              "kvm"
              "benchmark"
            ];
            protocol = "ssh-ng";
          })
          (filterAttrs
            (name: value:
              value.config.hey.isBuilder && name != config.networking.hostName)
            nodes);
      };
    })

    # Hosts that are builders
    (mkIf cfg.isBuilder {
      users.groups.builder = {};
      users.users.builder = {
        isSystemUser = true;
        group = "builder";
        openssh.authorizedKeys.keys = config.hey.keys.lychee.ssh;
        useDefaultShell = true;
      };
      services.openssh.extraConfig = ''
        Match User builder
          DisableForwarding yes
          PermitTTY no
          PermitTunnel no
        Match All
      '';
      nix.settings.trusted-users = ["builder"];
    })
  ];
}
