{ config, ... }:
{

  deployment.keys.nextcloud-admin = {
    destDir = "/var/lib/secrets";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/nextcloud-admin.gpg)
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "itslychee@proton.me";
  };
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "cloudy.wires.cafe";
    appstoreEnable = false;
    configureRedis = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.deployment.keys.nextcloud-admin.path;
    };

    database = {
      createLocally = true;
    };

  };
  networking.firewall.allowedTCPPorts = [ 443 ];

}
