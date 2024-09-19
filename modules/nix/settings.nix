{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mapAttrs' mapAttrsToList filterAttrs;
  inputFarm = pkgs.linkFarm "input-farm" (mapAttrsToList (name: path: {
      inherit
        name
        path
        ;
    })
    (filterAttrs (name: value: name != "self") inputs));
in {
  # Unfree stuff <3
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lix;
    nixPath = [inputFarm.outPath];
    registry =
      mapAttrs' (name: val: {
        inherit name;
        value.flake = val;
      })
      inputs;
    channel.enable = false;
    settings = {
      nix-path = config.nix.nixPath;
      keep-outputs = true;
      keep-derivations = true;
      accept-flake-config = false;
      flake-registry = "";
      substituters = [
        "https://lychee.cachix.org"
        "https://cache.wires.cafe/lychee-config"
      ];
      trusted-substituters = [
        "https://lychee.cachix.org"
        "https://cache.wires.cafe/lychee-config"
      ];
      trusted-public-keys = [
        "lychee.cachix.org-1:hyDZbHeziUb/pgU79Gy7wd6aGka8WQByZjP2DAalICw="
        "lychee-config:GY2kZ9k4bdq5TprB9IQprrDHoF5VZyKufG9ozZykEu0="
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      max-jobs = "auto";
      experimental-features = [
        "flakes"
        "nix-command"
        "no-url-literals"
        "repl-flake"
        "cgroups"
        "auto-allocate-uids"
      ];
      use-cgroups = true;
    };
  };

  # thank u raf
  systemd.tmpfiles.rules = lib.mkIf (!config.nix.channel.enable) [
    "R /root/.nix-defexpr/channels - - - -"
    "R /nix/var/nix/profiles/per-user/root/channels - - - -"
  ];
}
