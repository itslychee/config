{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce;
in {
  boot.kernelParams = ["intel_iommu=on"];
  boot.loader.systemd-boot.enable = true;

  hey.caps.headless = true;
  hey.users.lychee.enable = mkForce false;
  hey.users.student = {
    enable = true;
    passwordFile =
      (pkgs.writeText
        "hash" "$y$j9T$m5s/dPahYaBtgjtKS0oiB1$ySOzkUNyXVwRLsJovfZa1fIz2oebLRm6x6P8lbUcUR6")
      .outPath;
    groups = ["libvirtd" "wheel"];
    inherit (config.hey.users.lychee) sshKeys;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "nextcloud.local";
    configureRedis = true;
    database.createLocally = true;
    caching.redis = true;
    config.adminpassFile = "/var/lib/nextcloud/password";
  };

  networking.firewall.allowedTCPPorts = [80 443 25565];
  networking.interfaces.eno3.useDHCP = false;

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = ["virbr0" "eno3"];
  };

  system.stateVersion = "23.11";
}
