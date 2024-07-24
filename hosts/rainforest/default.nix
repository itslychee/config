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

  services.ntp = {
    enable = true;
    servers = [
      "0.us.pool.ntp.org"
      "1.us.pool.ntp.org"
      "2.us.pool.ntp.org"
      "3.us.pool.ntp.org"
    ];
  };

  services.atftpd = {
    enable = true;
    root = "/var/lib/nextcloud/data/F6E8B25D-A5E6-457F-8051-B19BB63CA477/files/Shared/ISOs";
  };

  networking.firewall = {
    allowedTCPPorts = [80 443 25565];
    allowedUDPPorts = [123 69];
  };
  system.stateVersion = "23.11";
}
