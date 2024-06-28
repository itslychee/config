{
  config,
  lib,
  ...
}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  services.openssh.enable = lib.mkDefault config.hey.caps.headless;

  networking.networkmanager.unmanaged = [config.services.tailscale.interfaceName];
  networking.networkmanager.enable = lib.mkDefault true;
  programs.ssh = {
    startAgent = true;
    agentTimeout = "30m";
    extraConfig = ''
      Host big-floppa
        User student
    '';
  };
  systemd.network.wait-online.ignoredInterfaces = [config.services.tailscale.interfaceName];
}
