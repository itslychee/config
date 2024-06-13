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
      age.secrets.lychee-password.file = ../secrets/lychee-password.age;
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
          "libvirt"
          "video" # needed for light
          "networkmanager"
          "wireshark"
        ];
        packages = flatten [
          (optionals config.hey.caps.graphical [
            (pkgs.discord-canary.override {withVencord = true;})
            pkgs.anki
            pkgs.qbittorrent
            pkgs.firefox
          ])
        ];
      };

      environment.systemPackages = builtins.attrValues {
        inherit
          (pkgs)
          htop
          ripgrep
          jq
          nmap
          nixpkgs-review
          ;
      };
      programs.wireshark.enable = config.hey.caps.graphical;
    }
  ];
}
