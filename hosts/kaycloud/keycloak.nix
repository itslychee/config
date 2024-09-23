{ config, ... }:
{

  deployment.keys.psql-keycloak = {
    destDir = "/var/lib/secrets/keycloak";
    keyCommand = [
      "gpg"
      "--decrypt"
      "${../../secrets/keycloak-psql.gpg}"
    ];
  };

  services.keycloak = {
    enable = true;
    initialAdminPassword = "DSAcOdAsUPLpGA==";
    settings = {
      hostname = "identity.wires.cafe";
      proxy = "edge";
      http-host = "127.0.0.1";
      http-port = 20000;
    };
    database.passwordFile = config.deployment.keys.psql-keycloak.path;

  };

  services.caddy = {
    enable = true;
    virtualHosts."identity.wires.cafe".extraConfig = ''
      reverse_proxy ${config.services.keycloak.settings.http-host}:${toString config.services.keycloak.settings.http-port}
    '';
  };
}
