{
  config,
  lib,
  ...
}:
# Used https://github.com/Gerg-L/nixos/blob/master/modules/builders.nix
# as a reference to figure out how builders work. thanks froge!

let
  cfg = config.hey.nix.builders;
  inherit (lib) mkIf mkMerge mkOption;
  inherit (lib.types) bool str nullOr;
in {
  # known_hosts are in modules/networking.nix
  options.hey.nix.builders = {
    use = mkOption {
      default = true;
      type = bool;
      description = "Should host use provided builders";
    };
    serveWithKey = mkOption {
      type = nullOr str;
      description = "If provided with a non-nix path, this host will be designated as a builder";
      default = null;
    };
  };
  config = mkMerge [
    (mkIf cfg.serveWithKey {

      # create a user for the builder to.. build!
      users.users = {
        groups.builder = {};
        users.builders = {
          createHome = false;
          isSystemUser = true;
          group = "builder";
          openssh.authorizedKeys.keys = config.hey.keys.users.lychee.builder;
        };
      };

      services.openssh.extraConfig = lib.mkBefore ''
        Match User builder
          DisableForwarding yes
          PermitTTY no
      '';

      nix = {
        settings = {
          trusted-users = [ "nix-ssh" "builder" ];
          secret-key-files = cfg.serveWithKey;
        };
      };

    })
  ];
}
