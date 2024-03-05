{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mapAttrs' mkEnableOption;
  inherit (config.hey) nix;
in {
  options.hey.nix = {
    enable = mkEnableOption "Nix";
  };
  config = mkIf nix.enable {
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
        trusted-users = ["@wheel" "root"];
        builders-use-substitutes = true;
        use-xdg-base-directories = true;
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
  };
}
