{
  config,
  lib,
  pkgs,
  ...
}: {
  services.blocky = {
    enable = false;
    settings = {
      caching = {
        minTime = "20m";
        prefetching = true;
      };
      upstreams.groups = {
        default = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };
      customDNS.customTTL = "24h";
      blocking.blackLists.ads = [
        "${pkgs.stevenblack-blocklist}/hosts"
      ];
      blocking.clientGroupsBlock.default = ["ads"];
    };
  };

  networking.firewall = lib.mkIf config.services.blocky.enable {
    # DNS port
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
}
