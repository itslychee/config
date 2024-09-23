{
  config,
  lib,
  ...
}:
let
  inherit (config.services.tailscale) interfaceName;
in
{
  config = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };

    services.openssh.enable = true;
    networking.firewall.interfaces.${interfaceName} = {
      allowedTCPPorts = [ 22 ];
    };
  };
}
