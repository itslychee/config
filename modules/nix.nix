{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mapAttrs';
in {
  nixpkgs.config.allowUnfree = true;
  nix = {
    nixPath = ["nixpkgs=flake:nixpkgs"];
    registry =
      mapAttrs' (name: val: {
        inherit name;
        value.flake = val;
      })
      inputs;
    settings = {
      substituters = [
        "https://cache.garnix.io"
        "https://colmena.cachix.org"
      ];
      trusted-substituters = [
        "https://cache.garnix.io"
        "https://colmena.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
      ];
      trusted-users = ["@wheel" "root"];
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
