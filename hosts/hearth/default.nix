{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.wifi.file = "${inputs.self}/secrets/wifi.age";
  boot = {
    kernelParams = ["irqpoll"];
    loader.systemd-boot.enable = true;
  };

  services = lib.genAttrs ["sonarr" "radarr" "jellyfin"] (name: {
    enable = true;
    openFirewall = true;
  });

  hey = {
    services = {
      openssh.enable = true;
      kmscon.enable = false;
      pipewire.enable = true;
    };

    users.lychee = {
      enable = true;
      wms.sway.enable = true;
    };
  };
  networking = {
    firewall = {
      allowedTCPPorts = [1113];
      allowedUDPPorts = [1113];
    };
    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [config.age.secrets.wifi.path];
        profiles.homeWifi = {
          connection.type = "wifi";
          connection.id = "$SSID";
          wifi.ssid = "$SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$PASSWORD";
          };
        };
      };
    };
  };
  # do not touch ever! #
  system.stateVersion = "24.05";
}
