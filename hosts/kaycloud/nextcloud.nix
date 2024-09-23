{
  config,
  inputs,
  ...
}:
{
  imports = [
    "${inputs.nextcloud-caddy}/nextcloud-extras.nix"
  ];
  services.nextcloud = {
    enable = true;
    webserver = "caddy";
    https = true;
    hostName = "cloudy.wires.cafe";
    notify_push.enable = true;
    database.createLocally = true;
    caching.redis = true;
    maxUploadSize = "2G";
    config = {
      dbtype = "pgsql";
      objectstore.s3 = {
        enable = true;
        key = "GKca354f345e9efc1db3dd69e7";
        hostname = "s3.wires.cafe";
        autocreate = false;
        region = "garage";
        bucket = "nextcloud";
        secretFile = config.deployment.keys.nextcloud-bucket.path;
        usePathStyle = true;
      };
      adminpassFile = config.deployment.keys.nextcloud-admin.path;
    };
  };

  deployment.keys = {
    nextcloud-bucket = {
      destDir = "/var/lib/secrets/nextcloud/bucket";
      user = "nextcloud";
      keyCommand = [
        "gpg"
        "--decrypt"
        (toString ../../secrets/nextcloud-bucket-secret.gpg)
      ];
    };
    nextcloud-sse-c-key = {
      destDir = "/var/lib/secrets/nextcloud/bucket-sse";
      user = "nextcloud";
      keyCommand = [
        "gpg"
        "--decrypt"
        (toString ../../secrets/nextcloud-sse-c-key.gpg)
      ];
    };
    nextcloud-admin = {
      destDir = "/var/lib/secrets/nextcloud/admin";
      user = "nextcloud";
      keyCommand = [
        "gpg"
        "--decrypt"
        (toString ../../secrets/nextcloud-admin.gpg)
      ];
    };
  };

  services.caddy.virtualHosts."s3.wires.cafe".extraConfig = ''
    reverse_proxy http://127.0.0.1:3900
  '';
}
