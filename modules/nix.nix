{
  config,
  pkgs,
  lib,
  inputs,
  mylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.hey) nix;
in {
  options.hey.nix = {
    enable = mylib.mkDefaultOption;
  };
  config = mkIf nix.enable {
    nixpkgs.config.allowUnfree = true;
    nix = {
      nixPath = ["nixpkgs=flake:nixpkgs"];
      sshServe = {
        protocol = "ssh-ng";
        keys = config.hey.keys.users.lychee;
        enable = true;
      };
      channel.enable = false;
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
