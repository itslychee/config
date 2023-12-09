_: {
  config,
  lib,
  ...
}: let
  cfg = config.hey.config;
in {
  options = {
    hey.config.nix = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether or not Nix should be configured with defaults";
    };
  };
  config = lib.mkIf cfg.nix {
    # Nix settings
    nix.settings = {
      auto-optimise-store = true;
      trusted-users = [
        "@wheel"
        "root"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Nix garbage collection
    nix.gc = {
      persistent = true;
      automatic = "-d --delete-older-than 20d";
      dates = "3d";
      optimise = {
        automatic = true;
        dates = ["daily"];
      };
    };
  };
}
