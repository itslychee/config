{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption optional;
  inherit (lib.types) package nullOr;
in {
  programs = {
    ssh = {
      enable = true;
      compression = true;
      addKeysToAgent = "yes";
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
      difftastic.enable = true;
      userName = "itslychee";
      userEmail = "itslychee@protonmail.com";
      signing = {
        signByDefault = true;
        key = "~/.ssh/id_ed25519";
      };
      extraConfig.gpg.format = "ssh";
      ignores = [
        "*.swp"
        "*~"
      ];
    };
  };
  home.packages = [inputs.self.packages.${pkgs.system}.nvim];
}
