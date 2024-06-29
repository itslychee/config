{
  pkgs,
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

  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online.serviceConfig = {
    ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  };
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
