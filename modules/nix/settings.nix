{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mapAttrs';
in {
  nixpkgs.config.allowUnfree = true;

  # Thank you Gerg!
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/inputs/${name}";
      value.source = value;
    })
    inputs;

  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  nix = {
    package = pkgs.lix;
    nixPath = ["/etc/nix/inputs"];
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
        "https://cache.garnix.io"
        "https://lychee.cachix.org"
      ];
      trusted-substituters = ["lychee.cachix.org-1:hyDZbHeziUb/pgU79Gy7wd6aGka8WQByZjP2DAalICw="];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lychee.cachix.org-1:hyDZbHeziUb/pgU79Gy7wd6aGka8WQByZjP2DAalICw="
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      max-jobs = "auto";
      experimental-features = [
        "flakes"
        "nix-command"
        "no-url-literals"
        "repl-flake"
        "cgroups"
      ];
    };
  };
}
