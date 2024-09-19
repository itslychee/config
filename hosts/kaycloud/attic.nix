{
  config,
  lib,
  ...
}: {
  deployment.keys.attic-key = {
    destDir = "/var/lib/secrets/attic";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../../secrets/attic.env.gpg)
    ];
  };

  services.atticd = {
    enable = true;
    credentialsFile = config.deployment.keys.attic-key.path;
    settings = {
      allowed-hosts = [
        config.networking.hostName
        "cache.wires.cafe"
      ];
      listen = "[::1]:30400";
      api-endpoint = "https://cache.wires.cafe/";
      database.url = "postgresql:///atticd?host=/run/postgresql";

      storage = {
        type = "s3";
        bucket = "attic";
        endpoint = "https://s3.wires.cafe";
        region = "garage";
      };
      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = lib.singleton {
      name = "atticd";
      ensureDBOwnership = true;
    };
    ensureDatabases = ["atticd"];
  };

  services.caddy.virtualHosts."cache.wires.cafe".extraConfig = ''
    reverse_proxy http://[::1]:30400
  '';
}
