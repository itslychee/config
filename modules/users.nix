{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge flatten optionals;
  cfg = config.hey.users.lychee;
in {
  config = mkMerge [
    (mkIf cfg.usePasswdFile {
      age.secrets.lychee-password.file = mkIf cfg.usePasswdFile ../secrets/lychee-password.age;
    })
    {
      # should be obvious why this is global
      hey.users.lychee = {
        enable = true;
        usePasswdFile = true;
        sshKeys = config.hey.keys.users.lychee.ssh;
        passwordFile = mkIf cfg.usePasswdFile config.age.secrets.lychee-password.path;
        groups = [
          "wheel"
          "audio"
          "video" # needed for light
          "networkmanager"
        ];
        packages = flatten [
          (optionals config.hey.caps.graphical [
            (pkgs.discord-canary.override {withVencord = true;})
            pkgs.anki
            pkgs.qbittorrent
            pkgs.firefox
          ])
          [pkgs.ripgrep pkgs.jq]
        ];
      };
    }
  ];
}
