{
  pkgs,
  config,
  inputs,
  lib,
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
    openssh.authorizedKeys.keys = config.hey.keys.users.lychee.ssh;
    extraGroups = ["wheel" "video"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
    shell = pkgs.zsh;
    packages = mkIf config.hey.caps.graphical [
        pkgs.anki
    ];
  };
  hey.users.lychee = {
    packages = [pkgs.ripgrep];

    root.".ssh/config".source = pkgs.writeText "ssh" ''
      Host *
        AddKeysToAgent yes
        IdentitiesOnly yes
    '';

    programs.zsh.enable = true;
    programs.git = {
      enable = true;
      config = {
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
