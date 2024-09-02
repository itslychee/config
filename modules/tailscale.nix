{
  config,
  lib,
  ...
}: let
  inherit (config.services.tailscale) interfaceName;
in {
  options.services.tailscale.ip = lib.mkOption {
    type = lib.types.str;
  };
  config = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };

    services.openssh.openFirewall = false;
    networking.firewall.interfaces.${interfaceName} = {
      allowedTCPPorts = [22];
    };
  };
}
