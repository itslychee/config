{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    flatten
    optionals
    ;
in {
  # should be obvious why this is global
  hey.users.lychee = {
    enable = true;
    usePasswdFile = true;
    passwordFile =
      (pkgs.writeText
        "hash" "$y$j9T$i6s3FePGTaI/qFEI.DGnO/$Z80iTqKXQCu3AF8qsOkThNFN/eHisyfXirpjSZ4N.N6")
      .outPath;
    groups = [
      "wheel"
      "audio"
      "libvirtd"
      "video" # needed for light
      "networkmanager"
      "wireshark"
    ];
    sshKeys = config.hey.keys.lychee.ssh;
    packages = flatten [
      (optionals config.hey.caps.graphical (builtins.attrValues {
        inherit
          (pkgs)
          anki
          qbittorrent
          firefox
          gimp
          ;
      }))
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

  programs.wireshark = {
    package = pkgs.wireshark;
    enable = config.hey.caps.graphical;
  };
}
