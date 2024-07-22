{
  pkgs,
  config,
  ...
}: {
  boot.kernelParams = ["intel_iommu=on"];
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hey = {
    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAKg9ZgbTR5ftw+nrm+Ch7Xl4LBs4z9M+e45/K0pG4u";
    caps.headless = true;
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
  system.stateVersion = "23.11";
}