{
  pkgs,
  config,
  inputs,
  lib,
  mylib,
  ...
}: let
  cfg = config.hey.users;
  inherit (lib) mkIf;
in {
  imports = [./sway.nix];
  age.secrets = mkIf cfg.lychee.enable {
    lychee-password.file = "${inputs.self}/secrets/lychee-password.age";
  };
  users.users.lychee = mkIf cfg.lychee.enable {
    isNormalUser = true;
    openssh.authorizedKeys.keys = mylib.keys.all config.hey.keys.users.lychee;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
  };
  hey.users.lychee = {
    packages = [ pkgs.ripgrep ];
    programs.git = {
      enable = true;
      extraConfig = {
        user = {
          email = "itslychee@protonmail.com";
          name = "itslychee";
          signingkey = "~/.ssh/id_ed25519.pub";
        };
        commit.gpgsign = true;
        gpg.format = "ssh";
      };
    };
  };
}
