{
  config,
  lib,
  ...
}: let
  cfg = config.hey.network;
  inherit (lib) mkEnableOption;
in {
  options.hey.network = {
    useNetworkd = mkEnableOption "Networkd";
  };

  config = lib.mkIf cfg.networkd {
    systemd.network.enable = true;
    networking = {
      useNetworkd = true;
      dhcpcd.enable = false;
    };
  };
}
