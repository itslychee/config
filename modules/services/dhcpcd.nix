{ config, lib, mylib, ...}:
let
  cfg = config.hey.network;
in
{

  options.hey.network = {
    useNetworkd = mylib.mkDefaultOption;
  };

  config = lib.mkIf cfg.networkd {
    systemd.network.enable = true;
    networking = {
      useNetworkd = true;
      dhcpcd.enable = false;
    };
  };

}
