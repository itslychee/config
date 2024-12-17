{
  pkgs,
  config,
  lib,
  ...
}:
{

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

  services.netbox = {
    enable = true;
    package = pkgs.netbox;
    settings = {
      CSRF_TRUSTED_ORIGINS = [ "https://netbox.ratlabs.co" ];
    };
    secretKeyFile = config.deployment.keys.netbox-secret.path;
  };

  services.caddy = {
    enable = true;
    virtualHosts."netbox.ratlabs.co".extraConfig = ''
      route /static* {
        uri strip_prefix /static
        root * ${config.services.netbox.dataDir}/static
        file_server
      }
      @notStatic not path /static*
      reverse_proxy @notStatic ${config.services.netbox.listenAddress}:${toString config.services.netbox.port}
      encode gzip zstd
      log {
        level error
      }
      tls {
        ca https://ca.ratlabs.co/acme/acme/directory
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

  users.groups.netbox.members = [ config.services.caddy.user ];
}
