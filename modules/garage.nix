{
  config,
  pkgs,
  lib,
  ...
}: {
  deployment.keys.garage-secrets = {
    destDir = "/var/lib/private/garage";
    keyCommand = [
      "gpg"
      "--decrypt"
      (toString ../secrets/garage-secrets.gpg)
    ];
  };
  services.garage = {
    package = pkgs.garage_1_0_0;
    environmentFile = "/var/lib/private/garage/garage-secrets";
    settings = {
      rpc_bind_addr = "[::]:9000";
      rpc_public_addr = "[::]:9000";
      root_domain = "s3.wires.cafe";
      replication_factor = 3;
      consul_discovery = {
        consul_http_addr = "http://127.0.0.1:8500";
        service_name = "garage-s3";
      };

      s3_api = {
        api_bind_addr = "[::]:9001";
        s3_region = "lychee";
      };
    };
  };
}
