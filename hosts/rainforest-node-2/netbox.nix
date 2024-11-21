{ pkgs, config, ... }:
{

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
}
