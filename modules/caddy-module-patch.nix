{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.caddy.enable {
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
