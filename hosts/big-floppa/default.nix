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

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAKg9ZgbTR5ftw+nrm+Ch7Xl4LBs4z9M+e45/K0pG4u";
    caps.headless = true;
    users.lychee.enable = mkForce false;
    users.student = {
      enable = true;
      groups = ["libvirtd" "wheel"];
      inherit (config.hey.users.lychee) sshKeys passwordFile;
    };
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "nextcloud.local";
    configureRedis = true;
    database.createLocally = true;
    caching.redis = true;
    settings.trusted_domains = [config.networking.hostName];
    config.adminpassFile = "/var/lib/nextcloud/password";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    shares.public = {
      path = "/var/lib/nextcloud/data/13DE9EF2-5EAE-461D-B31C-C170BFD093B7/files/ISOs";
      browseable = "yes";
      public = "yes";
      available = "yes";
      # comment = "Read-only ISO share, login via NextCloud to add ISOs";
      "read only" = "yes";
      "guest ok" = "yes";
      "force user" = "nextcloud";
      "force group" = "nextcloud";
      "guest account" = "nextcloud";
      "guest only" = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 25565];
  networking.interfaces.eno3.useDHCP = false;

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = ["virbr0" "eno3"];
  };

  system.stateVersion = "23.11";
}
