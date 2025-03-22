{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mapAttrs' mapAttrsToList filterAttrs;
  inputFarm = pkgs.linkFarm "input-farm" (
    mapAttrsToList (name: path: {
      inherit
        name
        path
        ;
    }) (filterAttrs (name: _value: name != "self") inputs)
  );
in
{
  # Unfree stuff <3
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ inputFarm.outPath ];
    registry = mapAttrs' (name: val: {
      inherit name;
      value.flake = val;
    }) inputs;
    channel.enable = false;
    settings = {
      nix-path = config.nix.nixPath;
      keep-outputs = true;
      keep-derivations = true;
      accept-flake-config = false;
      flake-registry = "";
      trusted-users = [
        "@wheel"
        "root"
      ];
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      max-jobs = "auto";
      experimental-features = [
        "flakes"
        "nix-command"
        "no-url-literals"
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
