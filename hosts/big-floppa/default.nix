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
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAKg9ZgbTR5ftw+nrm+Ch7Xl4LBs4z9M+e45/K0pG4u";
    caps.headless = true;
    users.lychee.enable = mkForce false;
    users.student = {
      enable = true;
      groups = ["libvirtd" "wheel"];
      inherit (config.hey.users.lychee) sshKeys passwordFile;
    };
    isBuilder = true;
  };

  services.nginx.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "cloud.rain.forest";
    configureRedis = true;
    package = pkgs.nextcloud29;
    database.createLocally = true;
    autoUpdateApps.enable = true;
    caching.redis = true;
    config = {
      dbtype = "pgsql";
      adminuser = "administrator";
      adminpassFile = "/var/lib/nextcloud/password";
    };
    settings.trusted_domains = [
      config.networking.hostName
      config.services.nextcloud.hostName
    ];
  };

  networking.firewall.allowedTCPPorts = [80 443 25565];
  # For Kali VM to properly configure its own
  # DNS and to appear like a separate device
  networking.interfaces.eno3.useDHCP = false;

  system.stateVersion = "23.11";
}
