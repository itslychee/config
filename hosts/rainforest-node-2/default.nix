{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hey = {
    users.mc = {
      inherit (config.hey.users.lychee) sshKeys enable;
    };

    hostKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSuccGN1fYQQqKWK5Eg+Ldj7H1a6LDIJsXxI3646Jgg";
  };

  deployment.keys.netbox-secret = {
    destDir = "/var/lib/secrets/netbox";
    user = "netbox";
    group = "netbox";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/netbox-secret.gpg)
    ];
  };

  hey.remote.builder = {
    enable = true;
    maxJobs = 20;
    speedFactor = 100;
  };

  services.netbox = {
    enable = true;
    package = pkgs.netbox;
    settings = {
      CSRF_TRUSTED_ORIGINS = [ "http://rainforest-node-2" ];
    };
    secretKeyFile = config.deployment.keys.netbox-secret.path;
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."rainforest-node-2" = {
    locations = {
      "/" = {
        proxyPass = "http://${config.services.netbox.listenAddress}:${toString config.services.netbox.port}";
        extraConfig = ''
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
      "/static/".alias = "${config.services.netbox.dataDir}/static/";
    };
  };
  users.groups.netbox.members = [ config.services.nginx.user ];

  services.consul.extraConfig = {
    server = true;
  };
  system.stateVersion = "24.05";
}
