{
  config,
  nodes,
  lib,
  ...
}: {
  services.consul = {
    interface = lib.genAttrs ["bind" "advertise"] (_: config.services.tailscale.interfaceName);
    extraConfig = {
      retry_join = builtins.attrNames nodes;
    };
    alerts.enable = true;
  };
}
