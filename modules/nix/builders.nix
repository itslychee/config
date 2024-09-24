{
  config,
  nodes,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    mkEnableOption
    mkOption
    mapAttrsToList
    filterAttrs
    flatten
    ;
  inherit (lib.types) number;
  cfg = config.hey.remote;
  builders = filterAttrs (
    _name: value: value.config.hey.remote.builder.enable && _name != config.networking.hostName
  ) nodes;
  mkNumericOption = opts: (mkOption { type = number; } // opts);
in
{
  options.hey.remote = {
    use = mkOption {
      default = false;
      description = "Use remote builder infrastructure";
    };
    builder = {
      enable = mkEnableOption "Serve as a Nix builder for my infrastructure";
      maxJobs = mkNumericOption { };
      speedFactor = mkNumericOption { };
    };
  };

  config = mkMerge [
    # Builder
    (mkIf cfg.builder.enable {
      hey.users.builder = {
        enable = true;
        sshKeys = flatten (mapAttrsToList (_name: value: value.config.hey.hostKeys) nodes);
      };
      nix.settings.trusted-users = [ "builder" ];
      # Inspired by https://github.com/Gerg-L/nixos/blob/d9b34c246450bf359fb00ff3fee7a7b86b936135/hosts/gerg-desktop/services/nix-serve.nix#L26
      services.openssh.extraConfig = ''
        Match User builder
            DisableForwarding yes
            PermitTTY no
            PermitUserRC no
        Match All
      '';
    })
    # Builder consumer
    (mkIf cfg.use {
      nix = {
        buildMachines = mapAttrsToList (hostName: value: {
          inherit hostName;
          inherit (value.config.hey.remote.builder) speedFactor maxJobs;
          protocol = "ssh-ng";
          sshUser = "builder";
          # NOTE: For reader
          # even if you're deploying on a non-root account, you MUST know
          # that the root user will be the one SSHing into other machines, so your ~/.ssh means nothing.
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          systems = flatten [
            value.config.nixpkgs.hostPlatform.system
            value.config.boot.binfmt.emulatedSystems
          ];
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
        }) builders;
        distributedBuilds = true;
        settings = {
          builders-use-substitutes = true;
        };
      };
    })
  ];
}
