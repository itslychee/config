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
  programs.zsh = {
      enable = true;
      enableLsColors = false;
      vteIntegration = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;

  };
  users.users.lychee = mkIf cfg.lychee.enable {
    isNormalUser = true;
    openssh.authorizedKeys.keys = mylib.keys.all config.hey.keys.users.lychee;
    extraGroups = ["wheel" "video"];
    hashedPasswordFile = config.age.secrets.lychee-password.path;
    shell = pkgs.zsh;
  };
  hey.users.lychee = {
    packages = [pkgs.ripgrep];

    root.".ssh/config".source = pkgs.writeText "ssh" ''
        AddKeysToAgent yes
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
